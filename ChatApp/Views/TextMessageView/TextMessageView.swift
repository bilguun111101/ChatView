//
//  TextMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

final class TextMessageView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 300
    private lazy var textView : MessageTextView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private var controller : TextMessageController?
    private var textViewWidthController : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func prepareForReuse() {
        textView.resignFirstResponder()
    }
    
    func apply(_ layoutAttributes: ChatLayoutAttributes) {
        viewPortWidth = layoutAttributes.layoutFrame.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(with controller : TextMessageController) {
        self.controller = controller
    }
    
    func reloadData() {
        guard let controller else {
            return
        }
        textView.text = controller.message.text
        UIView.performWithoutAnimation {
            if #available(iOS 13.0, *) {
                textView.textColor = controller.type.isIncoming ? UIColor.label : .systemBackground
                textView.linkTextAttributes = [
                    .foregroundColor : controller.type.isIncoming ? UIColor.label : .systemBackground,
                    .underlineStyle : 1,
                    .underlineColor : controller.type.isIncoming ? UIColor.label : .systemBackground
                ]
            } else {
                let color = controller.type.isIncoming ? UIColor.black : .white
                textView.textColor = color
                textView.linkTextAttributes = [.foregroundColor : color, .underlineStyle : 1, .underlineColor : color]
            }
        }
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.spellCheckingType = .no
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = .all
        textView.font = .preferredFont(forTextStyle: .body)
        textView.scrollsToTop = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isExclusiveTouch = true
        
        addSubview(textView)
        let constraints : [NSLayoutConstraint] = [
            textView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        textViewWidthController = textView.widthAnchor.constraint(lessThanOrEqualToConstant: viewPortWidth * Constants.maxWidth)
        textViewWidthController?.isActive = true
    }
}

extension TextMessageView : AvatarViewDelegate {
    func avatarTapped() {
        if enableSelfSizingSupport {
            layoutMargins = layoutMargins == .zero ? .init(top: 50, left: 0, bottom: 50, right: 0) : .zero
            setNeedsLayout()
            if let cell = superview(of: UICollectionViewCell.self) {
                cell.contentView.invalidateIntrinsicContentSize()
            }
        }
    }
}

private final class MessageTextView : UITextView {
    override var isFocused: Bool {
        false
    }
    override var canBecomeFirstResponder: Bool {
        false
    }
    override var canBecomeFocused: Bool {
        false
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
}
