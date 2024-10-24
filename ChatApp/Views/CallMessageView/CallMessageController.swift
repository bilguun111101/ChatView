//
//  CallMessageController.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit

final class CallMessageController {
    weak var view : CallMessageView? {
        didSet {
            view?.reloadData()
        }
    }
    
    let message : RawMessage
    let type : MessagePosition
    
    private let bubbleController: BubbleController
    
    init(message: RawMessage, type: MessagePosition, bubbleController: BubbleController) {
        self.message = message
        self.type = type
        self.bubbleController = bubbleController
    }
}
