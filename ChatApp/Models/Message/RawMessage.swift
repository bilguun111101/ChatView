//
//  RawMessage.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import DifferenceKit

enum MessageType : String, Codable {
    case chat
    case member_added
    case member_left
    case member_removed
    case typing
    case call
    case conversation_name_changed
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let objectType = try container.decode(String.self)
        
        switch objectType {
        case "CHAT": self = .chat
        case "MEMBER_ADDED": self = .member_added
        case "MEMBER_LEFT" : self = .member_left
        case "MEMBER_REMOVED": self = .member_removed
        case "TYPING": self = .typing
        case "CALL": self = .call
        case "CONVERSATION_NAME_CHANGED": self = .conversation_name_changed
        default: self = .chat
        }
    }
}

enum MessageContentType : String, Codable {
    case call
    case text
    case image
    case video
    case gif
    case ad
    case post
    case place
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let contentType = try container.decode(String.self)
        
        switch contentType {
        case "CALL": self = .call
        case "TEXT": self = .text
        case "IMAGE": self = .image
        case "VIDEO": self = .video
        case "GIF": self = .gif
        case "AD": self = .ad
        case "POST": self = .post
        case "PLACE": self = .place
        default: self = .text
        }
    }
}

enum MessagePosition : Hashable, Codable {
    case incoming
    case outgoing
    
    var isIncoming : Bool {
        self == .incoming
    }
}

//enum MessageStatus : Hashable {
//    case sent
//    case received
//    case read
//}

struct RawMessage : Hashable, Codable {
    let _id : String
    let id : String?
    let conversation : String
    let sender : RawUser
    let text : String?
    let type : MessageType
//    var position : MessagePosition = .incoming
    let updatedAt : Date
    let objectType : MessageContentType
    let seenUsers : [String]
    let deletedUsers : [String : Bool]
    let createdAt : Date
    let gif : RawGIF?
//    let place : RawPlace
    let post : RawPost?
//    let ad : RawAD
    let reactions : [RawReaction]
    let images : [RawImage]?
    let video : RawVideo?
    let callRequest : RawCall?
}

struct DateGroup : Hashable {
    var _id : String
    var date : Date
    var value : String {
        ChatDateFormatter.shared.string(from: date)
    }
    
    init(_id: String, date: Date) {
        self._id = _id
        self.date = date
    }
}

extension DateGroup : Differentiable {
    public var differenceIdentifier : Int {
        hashValue
    }
    public func isContentEqual(to source : DateGroup) -> Bool {
        self == source
    }
}
