//
//  StatusView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

enum MessageStatus: Hashable {
    case sent

    case received

    case read
}

final class StatusView : UIView, StaticViewFactory {
    private lazy var imageView : UIImageView = .init(frame: bounds)
        .withoutAutoresizingMaskIntoConstraints
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        addSubview(imageView)
        let constraints : [NSLayoutConstraint] = [
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        let widthContraint = imageView.widthAnchor.constraint(equalToConstant: 15)
        widthContraint.priority = .init(rawValue: 999)
        widthContraint.isActive = true
        let heightContraint = imageView.heightAnchor.constraint(equalToConstant: 15)
        heightContraint.priority = .init(rawValue: 999)
        heightContraint.isActive = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func setup(with status : MessageStatus) {
        switch status {
        case .sent :
            imageView.image = UIImage()
            imageView.tintColor = .lightGray
        case .received:
            imageView.image = UIImage()
            imageView.tintColor = .systemBlue
        case .read:
            imageView.image = UIImage()
            imageView.tintColor = .systemBlue
        }
    }
}
