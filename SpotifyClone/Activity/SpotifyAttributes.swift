//
//  SpotifyAttributes.swift
//  SpotifyClone
//
//  Created by Guerin Steven Colocho Chacon on 24/04/23.
//

import Foundation
import ActivityKit



struct SpotifyAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var imageName: String
    }
}
