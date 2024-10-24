//
//  GroupInfoView.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import ChatLayout
import UIKit

final class GroupInfoView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 340
    private var controller : GroupInfoController?
    private var textLabelWidthController : NSLayoutConstraint?
    private lazy var textLabel : UILabel = .init()
        .withoutAutoresizingMaskIntoConstraints
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func apply(_ layoutAttributes: ChatLayoutAttributes) {
        viewPortWidth = layoutAttributes.layoutFrame.width
    }
    
    func setup(with controller : GroupInfoController?) {
        self.controller = controller
        reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func reloadData() {
        guard let controller else {
            return
        }
        var systemName : String = ""
        switch controller.message.type {
        case .conversation_name_changed:
            systemName = "arrow.clockwise"
        case .member_added:
            systemName = "checkmark"
        case .member_left:
            systemName = "door.left.hand.open"
        case .member_removed:
            systemName = "xmark"
        default : systemName = ""
        }
        
        let size : CGFloat = 14
        let configuration = UIImage.SymbolConfiguration(pointSize: size, weight: .regular)
        let symbol = UIImage(systemName: systemName, withConfiguration: configuration)?
            .withTintColor(.gray)
            .withRenderingMode(.alwaysOriginal)
        let symbolAttachment = NSTextAttachment()
        symbolAttachment.image = symbol
        symbolAttachment.bounds = CGRect(origin: .init(x: 0, y: -3), size: .init(width: size, height: size))
        
        let symbolString = NSAttributedString(attachment: symbolAttachment)
        let textString = NSMutableAttributedString(string: "  \(controller.message.text ?? "")")
        textString.insert(symbolString, at: 0)
        
        textLabel.attributedText = textString
    }
    
    func prepareForReuse() {
//        textLabel.resignFirstResponder()
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        
        textLabel.textColor = .gray
        textLabel.font = .systemFont(ofSize: 13, weight: .regular)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = .max
        
        addSubview(textLabel)
        let constraints : [NSLayoutConstraint] = [
            textLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            textLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        textLabelWidthController = textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: viewPortWidth * Constants.maxWidth)
        textLabelWidthController?.isActive = true
        textLabelWidthController?.priority = .init(rawValue: 999)
    }
}
