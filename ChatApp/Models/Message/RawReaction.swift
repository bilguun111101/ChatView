//
//  RawReaction.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

struct RawReaction : Hashable, Codable {
    let _id : String
    let createdAt : Date
    let message : String
    let type : String
    let updatedAt : Date
    let user : RawUser
}

