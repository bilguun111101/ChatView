//
//  AvatarPlaceholderView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

final class AvatarPlaceholderView : UIView, StaticViewFactory {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        let constraint = widthAnchor.constraint(equalToConstant: 30)
        constraint.priority = .init(rawValue: 999)
        constraint.isActive = true
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
}
