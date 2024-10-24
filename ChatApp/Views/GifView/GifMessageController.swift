//
//  GifMessageController.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation

final class GifMessageController {
    weak var view : GifMessageView? {
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
