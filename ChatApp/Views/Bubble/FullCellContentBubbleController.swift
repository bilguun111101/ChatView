//
//  FullCellContentBubbleController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit
import ChatLayout

final class FullCellContentBubbleController<CustomView : UIView> : BubbleController {
    weak var bubbleView : BezierMaskedView<CustomView>? {
        didSet {
            setupBubbleView()
        }
    }
    
    init(bubbleView: BezierMaskedView<CustomView>) {
        self.bubbleView = bubbleView
        setupBubbleView()
    }
    
    private func setupBubbleView() {
        guard let bubbleView else {
            return
        }
        UIView.performWithoutAnimation {
            bubbleView.backgroundColor = .clear
            bubbleView.customView.layoutMargins = .zero
        }
    }
}
