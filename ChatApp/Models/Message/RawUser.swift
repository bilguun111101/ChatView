//
//  RawUser.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

struct RawUser : Codable, Hashable {
    static func == (lhs: RawUser, rhs: RawUser) -> Bool {
        lhs._id == rhs._id
    }
    
    let _id : String
    let userType : String?
    let isActive : Bool?
    let firstName : String?
    let lastName : String?
    let avatar : RawAvatar?
    let nickname : String?
    let createdAt : Date
}

