//
//  RawPost.swift
//  ChatApp
//
//  Created by qq on 2024.10.23.
//

import Foundation

struct RawPostContent : Hashable, Codable {
    let _id : String
    let type : String?
    let thumbnail : URL?
//    let video : RawVideo?
    let image : RawImage?
    let text : String?
    let sharedTag : String?
}

struct RawPost : Hashable, Codable {
    let _id : String
    let user : RawUser?
//    let type : String
//    let objectType : String
//    let object : String?
//    let tags : []
//    let mentions : []
    let text : String?
    let contents : [RawPostContent]
    let sharePrivacy : String?
    let commentPrivacy : String?
    let privacy : String?
    let likeCount : Int?
    let createdAt : Date
    let isLiked : Bool?
    let isSaved : Bool?
    let url : String?
    let reported : Bool?
}
