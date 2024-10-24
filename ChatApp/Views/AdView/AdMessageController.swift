//
//  AdMessageController.swift
//  ChatApp
//
//  Created by qq on 2024.10.21.
//

import Foundation
import UIKit

final class AdMessageController {
    weak var view : AdMessageView? {
        didSet {
            view?.reloadData()
        }
    }
    
    let message : RawMessage
    let type : MessagePosition
    
    init(message: RawMessage, type: MessagePosition) {
        self.message = message
        self.type = type
    }
}
