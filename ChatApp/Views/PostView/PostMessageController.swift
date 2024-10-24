//
//  PostMessageController.swift
//  ChatApp
//
//  Created by qq on 2024.10.23.
//

import Foundation
import UIKit

final class PostMessageController {
    weak var view : PostMessageView? {
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
