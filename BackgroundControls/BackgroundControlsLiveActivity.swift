//
//  BackgroundControlsLiveActivity.swift
//  BackgroundControls
//
//  Created by Guerin Steven Colocho Chacon on 22/04/23.
//

import ActivityKit
import WidgetKit
import SwiftUI
import ImageIO

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
struct BackgroundControlsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SpotifyAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
           
                
                DynamicIslandExpandedRegion(.leading) {
                    ZStack{
                        if let imageContainer = FileManager.default.containerURL(
                            forSecurityApplicationGroupIdentifier: "group.com.steven.weatherapp")?
                            .appendingPathComponent(context.state.imageName),
                           let uiImage = UIImage(contentsOfFile: imageContainer.path()) {
                          
                            let reduceImage = uiImage.aspectFittedToHeight(75)
                            HStack{
                                Image(uiImage: reduceImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                    .frame(width: 53, height: 50)
                                    .cornerRadius(15)
                            }
                              
                          
                        }else {
                            HStack{
                                Rectangle().aspectRatio(contentMode: .fill)
                                    .frame(width: 53, height: 50)
                                    .cornerRadius(15)
                                
                            }
                        }
                    }                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading){
                        Text("Independiente").font(.system(size: 16)).fontWeight(.bold)
                        Text("Rich Vagos, Gera MX").fontWeight(.medium).font(.system(size: 14))
                            .foregroundColor(.gray)
                     
 
                    }.frame(maxWidth: .infinity, alignment:.leading).padding(.leading,10)
                       
                }
                DynamicIslandExpandedRegion(.bottom) {
                    
                    VStack{
                        HStack{
                            Text("0:26").foregroundColor(.gray).font(.system(size:12))
                            ZStack(alignment: .leading){
                                Rectangle().frame(maxWidth: 50, maxHeight: 5).cornerRadius(10)
                                Rectangle().frame(maxWidth: .infinity, maxHeight: 5).foregroundColor(.gray.opacity(0.2)).cornerRadius(10)
                            }
                            Text("-2:05").foregroundColor(.gray).font(.system(size:12))
                        }
                        HStack{
                            Spacer()
                            Image(systemName: "backward.fill").font(.system(size:19))
                            Spacer()
                            Image(systemName: "play.fill").font(.system(size:30))
                            Spacer()
                            Image(systemName: "forward.fill").font(.system(size:19))
                            Spacer()
                            Image(systemName: "airplayaudio").font(.system(size:24)).foregroundColor(.gray.opacity(0.7))
                        
                        }.frame(maxWidth: .infinity,maxHeight: 300)
                 
                    }
                    
                    
                }
            } compactLeading: {
                ZStack{
                    if let imageContainer = FileManager.default.containerURL(
                        forSecurityApplicationGroupIdentifier: "group.com.steven.weatherapp")?
                        .appendingPathComponent(context.state.imageName),
                       let uiImage = UIImage(contentsOfFile: imageContainer.path()) {
                      
                        let reduceImage = uiImage.aspectFittedToHeight(35)
                        HStack{
                            Image(uiImage: reduceImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 18, height: 18)
                            .cornerRadius(4)
                        }
                          
                      
                    }else {
                        HStack{
                            Rectangle().aspectRatio(contentMode: .fill)
                                .frame(width: 18, height: 18)
                                .cornerRadius(4)
                            
                        }
                    }
                }
            } compactTrailing: {
            
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct BackgroundControlsLiveActivity_Previews: PreviewProvider {
    static let attributes = SpotifyAttributes()
    static let contentState = SpotifyAttributes.ContentState(imageName: "")
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
