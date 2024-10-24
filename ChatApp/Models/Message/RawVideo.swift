//
//  RawVideo.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

struct RawVideo : Hashable, Codable {
    let _id : String
    let url : URL?
    let height : Int
    let width : Int
    let createdAt : Date
    
    enum CodingKeys: CodingKey {
        case _id
        case url
        case height
        case width
        case createdAt
    }
}

