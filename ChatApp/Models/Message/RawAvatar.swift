//
//  RawAvatar.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

struct RawAvatar : Hashable, Codable {
    let _id : String
    let url : URL?
    let uri : URL?
    let extraSmall : URL?
    let small : URL?
    let medium : URL?
    let large : URL?
    let extraLarge : URL?
    let user : String?
    let blurhash : String
    let width : Int?
    let height : Int?
    let type : String?
    let mediaType : MediaType?
    let createdAt : Date
    
    enum CodingKeys: CodingKey {
        case _id
        case url
        case uri
        case extraSmall
        case small
        case medium
        case large
        case extraLarge
        case user
        case blurhash
        case width
        case height
        case type
        case mediaType
        case createdAt
    }
}

