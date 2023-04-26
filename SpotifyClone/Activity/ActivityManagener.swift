//
//  ActivityManagener.swift
//  SpotifyClone
//
//  Created by Guerin Steven Colocho Chacon on 24/04/23.
//

import Foundation
import ActivityKit

class ActivityManager{
    
    
    
    static func  startActivity() async-> Void{
        let imageName = try! await self.downloadImage(from: URL(string: "https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/c3/64/4f/c3644f74-9808-96ae-4b03-87759115b164/0.jpg/1200x1200bf-60.jpg")!)
        let spotifyAttributes = SpotifyAttributes()
        let initState = SpotifyAttributes.ContentState(imageName: imageName)
        let activityContent = ActivityContent(state: initState, staleDate:  Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
        do {
            let activity = try Activity.request(attributes: spotifyAttributes, content: activityContent)
            
            print("Live Activity \(activity.id).")
        } catch (let error) {
            print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
        }
        
        
    }
    
    
    
    
    static func downloadImage(from url: URL) async throws -> String {
        guard var destination = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.steven.weatherapp")
        else { return "" }
        
        destination = destination.appendingPathComponent(url.lastPathComponent)
        
        guard !FileManager.default.fileExists(atPath: destination.path()) else {
            print("No need to download \(url.lastPathComponent) as it already exists.")
            print("successfull")
            return destination.lastPathComponent
        }
        
        let (source, _) = try await URLSession.shared.download(from: url)
        try FileManager.default.moveItem(at: source, to: destination)
        print("Done downloading \(url.lastPathComponent)!")
        print("successfull")
        return destination.lastPathComponent
    }
}
