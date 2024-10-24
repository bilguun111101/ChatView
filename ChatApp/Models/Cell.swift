//
//  Cell.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit
import DifferenceKit

enum Cell : Hashable {
    enum BubbleType {
        case normal
        case tailed
    }
    
    case message(RawMessage, bubbleType: BubbleType)
    case typingIndicator
    case messageGroup(MessageGroup)
    
    case date(DateGroup)
    
    var alignment : ChatItemAlignment {
        switch self {
        case .message(_, bubbleType: _):
//            message.position == .incoming ? .leading : .trailing
            .leading
        case .typingIndicator:
            .leading
        case let .messageGroup(group):
            group.type == .incoming ? .leading : .trailing
        case .date:
            .center
        }
    }
}

extension Cell : Differentiable {
    public var differenceIdentifier: String {
        switch self {
        case let .message(message, _):
            message._id
        case .typingIndicator:
            String(hashValue)
        case let .messageGroup(group):
            String(group.differenceIdentifier)
        case let .date(group):
            String(group.differenceIdentifier)
        }
    }
    
    public func isContentEqual(to source: Cell) -> Bool {
        self == source
    }
}
