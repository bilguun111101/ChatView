//
//  MessageGroup.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import DifferenceKit

struct MessageGroup : Hashable {
    var _id : String
    
    var title : String
    
    var type : MessagePosition
    
    init(_id: String, title: String, type: MessagePosition) {
        self._id = _id
        self.title = title
        self.type = type
    }
}

extension MessageGroup : Differentiable {
    public var differenceIdentifier : Int {
        hashValue
    }
    public func isContentEqual(to source: MessageGroup) -> Bool {
        self == source
    }
}
