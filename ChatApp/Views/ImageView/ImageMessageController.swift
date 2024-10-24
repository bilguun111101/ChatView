//
//  ImageMessageController.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit

final class ImageMessageController {
    weak var view : ImageMessageView? {
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
