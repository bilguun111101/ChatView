//
//  RawImage.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

enum ObjectTypee : String, Codable {
    case chat
    case unknown
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let objectType = try container.decode(String.self)
        
        switch objectType {
        case "CHAT": self = .chat
        default: self = .unknown
        }
    }
}

enum MediaType : String, Codable {
    case image
    case video
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let mediaType = try container.decode(String.self)
        
        switch mediaType {
        case "image" : self = .image
        case "video" : self = .video
        default : self = .image
        }
    }
}

struct RawImage : Hashable, Codable {
    let _id : String
    let blurhash : String?
    let conversation : String?
    let createdAt : Date?
    let deletedUsers : [String : Bool]?
    let extraLarge : URL?
    let extraSmall : URL?
    let height : Int
    let large : URL?
    let medium : URL?
    let message : URL?
    let objectType : ObjectTypee?
    let rotation : String?
    let small : URL?
    let updatedAt : Date?
    let url : URL?
    let user : String?
    let width : Int
    let mediaType : MediaType
}

