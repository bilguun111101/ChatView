//
//  TextBubbleController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

final class TextBubbleController<CustomView : UIView> : BubbleController {
    private let type : MessagePosition
    private let bubbleType : Cell.BubbleType
    
    weak var bubbleView : UIView? {
        didSet {
            setupBubbleView()
        }
    }
    
    init(type: MessagePosition, bubbleType: Cell.BubbleType, bubbleView: UIView? = nil) {
        self.type = type
        self.bubbleType = bubbleType
        self.bubbleView = bubbleView
        setupBubbleView()
    }
    
    private func setupBubbleView() {
        guard let bubbleView else { return }
        UIView.performWithoutAnimation {
            let marginOffset : CGFloat = type.isIncoming ? -Constants.tailSize : Constants.tailSize
            let edgeInsets : UIEdgeInsets = .init(top: 8, left: 16 - marginOffset, bottom: 8, right: 16 + marginOffset)
            bubbleView.layoutMargins = edgeInsets
            
            if #available(iOS 13.0, *) {
                bubbleView.backgroundColor = type.isIncoming ? .systemGray5 : .systemBlue
            } else {
                let systemGray5 = UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1)
                bubbleView.backgroundColor = type.isIncoming ? systemGray5 : .systemBlue
            }
        }
    }
}
