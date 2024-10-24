//
//  URLView.swift
//  ChatApp
//
//  Created by qq on 2024.10.19.
//

import Foundation
import ChatLayout
import LinkPresentation
import UIKit

final class URLView: UIView, ContainerCollectionViewCellDelegate {
    private var linkView : LPLinkView?
    private var controller : URLController?
    private var viewPortWidth : CGFloat = 300
    private var linkWidthConstraint : NSLayoutConstraint?
    private var linkHeightContraint : NSLayoutConstraint?
    
    var newLinkView: LPLinkView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
//    func prepareForReuse() {
//        linkView?.removeFromSuperview()
//        linkView = nil
//    }
    func apply(_ layoutAttributes: ChatLayoutAttributes) {
        viewPortWidth = layoutAttributes.layoutFrame.width
        setupSize()
    }
    
    func reloadData() {
        setupLinkView()
        if let cell = superview(of: UICollectionViewCell.self) {
            cell.contentView.invalidateIntrinsicContentSize()
        }
    }
    
    func setup(with controller : URLController) {
        self.controller = controller
    }
    
    private func setupLinkView() {
        linkView?.removeFromSuperview()
        guard let controller else {
            return
        }
        
        switch controller.metadata {
        case let .some(metadata):
            newLinkView = LPLinkView(metadata: metadata)
        case .none:
            if let url = controller.url {
                newLinkView = LPLinkView(url: url)
            }
            break
        }
        guard let newLinkView = newLinkView else { return }
        addSubview(newLinkView)
        newLinkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newLinkView.topAnchor.constraint(equalTo: topAnchor),
            newLinkView.bottomAnchor.constraint(equalTo: bottomAnchor),
            newLinkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newLinkView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        linkWidthConstraint = newLinkView.widthAnchor.constraint(equalToConstant: 310)
        linkWidthConstraint?.priority = UILayoutPriority(999)
        linkWidthConstraint?.isActive = true
        
        linkHeightContraint = newLinkView.heightAnchor.constraint(equalToConstant: 40)
        linkHeightContraint?.priority = UILayoutPriority(999)
        linkHeightContraint?.isActive = true
        
        linkView = newLinkView
    }
    
    private func setupSize() {
        guard let linkView else {
            return
        }
        let contentSize = linkView.intrinsicContentSize
        let maxWidth = min(viewPortWidth * Constants.maxWidth, contentSize.width)
        
        let newContentRect = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: contentSize.height * maxWidth / contentSize.width))
        
        linkWidthConstraint?.constant = newContentRect.width
        linkHeightContraint?.constant = newContentRect.height
        
        linkView.bounds = newContentRect
        linkView.sizeToFit()
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
