//
//  RawCall.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

enum CallType : String, Codable {
    case video
    case call
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try container.decode(String.self)
        
        switch type {
        case "VIDEO" : self = .video
        case "CALL" : self = .call
        default : self = .call
        }
    }
}

enum RequestStatus : String, Codable {
    case missed
    case end
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let status = try container.decode(String.self)
        
        switch status {
        case "MISSED" : self = .missed
        case "END" : self = .end
        default : self = .missed
        }
    }
}

struct RawCall : Hashable, Codable {
    let _id : String
    let type : CallType
    let user : RawUser
    let receiver : String
    let receiverConnected : Bool
    let receiverConnectedDate : Date
    let requestStatus : RequestStatus
    let requestStatusDate : Date
    let second : Double
    let createdAt : Date
    let updatedAt : Date
}
