//
//  RawGIF.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//


import Foundation

struct RawGIF : Hashable, Codable {
    let url : URL?
    let height : Int
    let width : Int
    let type : String
}

