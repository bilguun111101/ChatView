//
//  TextMessageController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

final class TextMessageController {
    weak var view : TextMessageView? {
        didSet {
            view?.reloadData()
        }
    }
    
    let message : RawMessage
    let type : MessagePosition
    
    private let bubbleController : BubbleController
    
    init(message: RawMessage, type: MessagePosition, bubbleController: BubbleController) {
        self.message = message
        self.type = type
        self.bubbleController = bubbleController
    }
}
