//
//  ContentView.swift
//  SpotifyClone
//
//  Created by Guerin Steven Colocho Chacon on 22/04/23.
//

import SwiftUI
import AVKit
import AVFoundation
import Foundation


struct ContentView: View {
    
    @State var value:Float = 0.2
    var videoView:PlayerView =   PlayerView()
    @Environment(\.scenePhase) private var phase
    var body: some View {
        
        GeometryReader{
            proxy in
            
                ZStack(alignment:.top){
                    ZStack{}.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black)
                    ScrollView(showsIndicators: false){
                        ZStack{
                            ZStack{
                                VStack(spacing: 0){
                                    videoView.frame(height:proxy.size.height + 30)
                                    
                                    
                                    Rectangle().frame(width: .infinity,height: 300).foregroundColor(.black)
                                }
                                
                            }
                            ZStack{}.frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.8),.black.opacity(0.9),.black]), startPoint: .top, endPoint: .bottom)
                                  )
                            VStack{
                                CustomAppBar()
                                Spacer()
                                songMetadataInformation(currentDuration: $value, totalDuration: $value).padding(.bottom,50)
                           
                                AVContentControls().frame(maxWidth: .infinity, maxHeight: 40).offset(x: 0, y: -(proxy.size.height / 30))
                                
                                songInformation()
                                self.lyrics()
                                   
                                
                            }
                        }
                    }
                } .ignoresSafeArea().frame(maxHeight: 7000)
            
        } .onChange(of: phase) { newPhase in
            
            
            switch newPhase {
           
                
            case .active : videoView.playVideo()
                
            default: break
            }
        }
    }
    
    @ViewBuilder
    func songMetadataInformation(currentDuration: Binding<Float>,totalDuration: Binding<Float>) -> some View{
        
       
        VStack(spacing: 0){
            Slider(value: currentDuration)  .accentColor(.white)
                .onAppear {
                    let progressCircleConfig = UIImage.SymbolConfiguration(scale: .small)
                    UISlider.appearance()
                        .setThumbImage(UIImage(systemName: "circle.fill",
                                               withConfiguration: progressCircleConfig), for: .normal)
                }
            HStack{
                Text("0:32").font(.system(size: 14))
                  
                    .foregroundColor(.white)
                Spacer()
                Text("3:56").font(.system(size: 14))
                    .foregroundColor(.white)
            }
        } .padding(.horizontal,20)
            .onAppear{
                Task{
                 await   ActivityManager.startActivity()
               
                }
            }
    }
    
    @ViewBuilder
    func songInformation() -> some View{
        
        HStack{
            Image("devices").resizable()
                .aspectRatio(contentMode: .fit).frame(maxWidth: 30, maxHeight: 30)
            Spacer()
            Image(systemName: "square.and.arrow.up").font(.system(size:20)).fontWeight(.bold)
                .foregroundColor(.white)
            Rectangle().frame(width: 20, height: 0)
            Image(systemName: "list.bullet.below.rectangle").font(.system(size:20))
                .fontWeight(.bold)
                .foregroundColor(.white)
        } .padding(.horizontal,20)
            .padding(.bottom,20)
    }
    
    @ViewBuilder
    func lyrics()-> some View{
        
        HStack(alignment: .top, spacing: 0){
        
            HStack(alignment: .top, spacing: 0){
                Text("Lyrics").font(.system(size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "square.and.arrow.up").font(.system(size:15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
                    .background(.black.opacity(0.3))
                    .cornerRadius(20)
                   
                Rectangle().frame(width: 20, height: 0)
                Button {
                    
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right").font(.system(size:15))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 35, height: 35)
                        .background(.black.opacity(0.3))
                        .cornerRadius(20)
                        .rotationEffect(Angle(radians: 55))
                }

            }.frame(height: 55)
          
        }
        .padding(.horizontal,20)
           
        .frame(maxWidth: .infinity, maxHeight: 270, alignment: .top)
            .background(Color.blue)
            .cornerRadius(5)
            .padding(.horizontal,10)
            .padding(.bottom, 20)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CustomAppBar: View {
    var body: some View{
        HStack{
            Image(systemName: "chevron.down")
                .font(.system(size:30))
                .foregroundColor(.white)
            Spacer()
            Text("Liked Songs").font(.system(size: 14))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            HStack{
                
                ForEach((1...3), id: \.self) {
                    _ in
                    Image(systemName: "circle.fill")
                        .font(.system(size:5))
                        .foregroundColor(.white)
                }.padding(.horizontal,-2)
               
            }
            
        }.padding(.top,70)
            .padding(.horizontal,20)
    }
}



struct AVContentControls: View{
    var body: some View{
        
        HStack{
            Image(systemName: "shuffle").font(.system(size:25))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "backward.end.fill").font(.system(size:30))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "play.circle.fill").font(.system(size:60))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "forward.end.fill").font(.system(size:30))
                .foregroundColor(.white)
            Spacer()
            Image(systemName: "repeat.1").font(.system(size:25))
                .foregroundColor(.white)
        }       .padding(.horizontal,20)
          
    }
}


struct PlayerView: UIViewRepresentable {
    var uiView:PlayerUIView = PlayerUIView(frame: .zero)
    
 func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    
 }
 func makeUIView(context: Context) -> UIView {
     uiView
 }
    
    func playVideo() -> Void {
        uiView.makeVideo()
    }


    
}

enum PlayerGravity {
    case aspectFill
    case resize
}
class PlayerUIView: UIView {
    
    private let playerLayer = AVPlayerLayer()
    let gravity: PlayerGravity =  PlayerGravity.aspectFill
    
    override static var layerClass: AnyClass {
          return AVPlayerLayer.self
      }
    func setupLayer() {
           switch gravity {
       
           case .aspectFill:
               playerLayer.contentsGravity = .resizeAspectFill
               playerLayer.videoGravity = .resizeAspectFill
               
           case .resize:
               playerLayer.contentsGravity = .resize
               playerLayer.videoGravity = .resize
               
           }
       }
    override init(frame: CGRect) {
        super.init(frame: frame)

    
        makeVideo()
        setupLayer()
    }
    
    func makeVideo()->Void{
        let player = AVPlayer(url:  Bundle.main.url(forResource: "gera", withExtension: "mov")!)
      
        player.seek(to: .zero)
        player.isMuted = false
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { notification in
            player.seek(to: .zero)
            player.play()
            player.isMuted = true
            
        }

        playerLayer.player = player

        layer.addSublayer(playerLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    
    
    
}


