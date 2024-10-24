//
//  BezierBubbleController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit
import ChatLayout

final class BezierBubbleController<CustomView : UIView> : BubbleController {
    private let controllerProxy : BubbleController
    private let type : MessagePosition
    private let bubbleType : Cell.BubbleType
    
    weak var bubbleView : BezierMaskedView<CustomView>? {
        didSet {
            setupBubbleView()
        }
    }
    
    init(controllerProxy: BubbleController, type: MessagePosition, bubbleType: Cell.BubbleType, bubbleView: BezierMaskedView<CustomView>) {
        self.controllerProxy = controllerProxy
        self.type = type
        self.bubbleType = bubbleType
        self.bubbleView = bubbleView
    }
    
    private func setupBubbleView() {
        guard let bubbleView else {
            return
        }
        bubbleView.messageType = type
        bubbleView.bubbleType = bubbleType
    }
}
