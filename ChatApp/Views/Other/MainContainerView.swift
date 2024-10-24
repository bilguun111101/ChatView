//
//  MainContainerView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

final class MainContainerView<LeadingAccessory : StaticViewFactory, CustomView : UIView, TrailingAccessory : StaticViewFactory> : UIView, SwipeNotifierDelegate {
    var swipeCompletionRate: CGFloat = 0 {
        didSet {
            updateOffset()
        }
    }
    
    var avatarView : LeadingAccessory.View? {
        containerView.leadingView
    }
    
    var customView : BezierMaskedView<CustomView> {
        containerView.customView
    }
    
    var statusView : TrailingAccessory.View? {
        containerView.trailingView
    }
    
    weak var accessoryConnectingView : UIView? {
        didSet {
            guard accessoryConnectingView != oldValue else {
                return
            }
            updateAccessoryView()
        }
    }
    
    var accessoryView : DateAccessoryView = .init()
        .withoutAutoresizingMaskIntoConstraints
    
    var accessorySafeAreaInsets: UIEdgeInsets = .zero {
        didSet {
            guard accessorySafeAreaInsets != oldValue else {
                return
            }
            accessoryOffsetConstraint?.constant = accessorySafeAreaInsets.right
            setNeedsLayout()
            updateOffset()
        }
    }
    
    private(set) lazy var containerView = CellLayoutContainerView<LeadingAccessory, BezierMaskedView<CustomView>, TrailingAccessory>()
    
    private weak var accessoryOffsetConstraint : NSLayoutConstraint?
    
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
        clipsToBounds = false
        
        addSubview(containerView)
        let constraints : [NSLayoutConstraint] = [
            containerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        updateOffset()
    }
    
    private func updateAccessoryView() {
        accessoryView.removeFromSuperview()
        guard let avatarConnectingView = accessoryConnectingView,
              let avatarConnectingSuperview = avatarConnectingView.superview else {
            return
        }
        avatarConnectingSuperview.addSubview(accessoryView)
        accessoryOffsetConstraint = accessoryView.leadingAnchor.constraint(equalTo: avatarConnectingView.trailingAnchor, constant: accessorySafeAreaInsets.right)
        accessoryOffsetConstraint?.isActive = true
        accessoryView.centerYAnchor.constraint(equalTo: avatarConnectingView.centerYAnchor).isActive = true
    }
    
    private func updateOffset() {
        if let avatarView,
           !avatarView.isHidden {
            avatarView.transform = CGAffineTransform(translationX: -((avatarView.bounds.width + accessorySafeAreaInsets.left) * swipeCompletionRate), y: 0)
        }
        switch containerView.customView.messageType {
        case .incoming:
            customView.transform = .identity
            customView.transform = .init(translationX: -(customView.frame.origin.x * swipeCompletionRate), y: 0)
        case .outgoing:
            let maxOffset = min(frame.origin.x, accessoryView.frame.width)
            customView.transform = .identity
            customView.transform = .init(translationX: -(maxOffset * swipeCompletionRate), y: 0)
            if let statusView,
               !statusView.isHidden {
                statusView.transform = .init(translationX: -(maxOffset * swipeCompletionRate), y: 0)
            }
        }
        
        accessoryView.transform = .init(translationX: -((accessoryView.bounds.width + accessorySafeAreaInsets.right) * swipeCompletionRate), y: 0)
    }
}
