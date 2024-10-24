//
//  GifMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.19.
//

import Foundation
import ChatLayout
import UIKit
import SDWebImage

final class GifMessageView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 300
    private lazy var imageView : SDAnimatedImageView = .init(frame: bounds)
        .withoutAutoresizingMaskIntoConstraints
    private var imageViewWidthContraint : NSLayoutConstraint?
    private var imageViewHeightContraint : NSLayoutConstraint?
    private var controller : GifMessageController?
    private lazy var stackView : UIStackView = .init(frame: bounds)
        .withoutAutoresizingMaskIntoConstraints
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup(with controller : GifMessageController) {
        self.controller = controller
        reloadData()
    }
    
    func reloadData() {
        guard let controller,
              let gif = controller.message.gif
        else { return }
        imageView.sd_setImage(with: gif.url)
        
        UIView.performWithoutAnimation { [weak self] in
            guard let self else {
                return
            }
            stackView.addArrangedSubview(imageView)
            imageViewHeightContraint?.isActive = true
            imageViewWidthContraint?.isActive = true
            imageViewHeightContraint?.constant = CGFloat(gif.height) / CGFloat(gif.width) * viewPortWidth * Constants.maxWidth
            setNeedsLayout()
            stackView.setNeedsLayout()
            stackView.layoutIfNeeded()
        }
    }
    
    func prepareForReuse() {
        imageView.image = nil
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        
        imageView.contentMode = .scaleAspectFill

        addSubview(stackView)
        let constraints : [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
        
        imageViewWidthContraint = imageView.widthAnchor.constraint(equalToConstant: viewPortWidth * Constants.maxWidth)
        imageViewWidthContraint?.priority = .init(rawValue: 999)
        
        imageViewHeightContraint = imageView.heightAnchor.constraint(equalToConstant: viewPortWidth * Constants.maxWidth)
        imageViewHeightContraint?.priority = .init(rawValue: 999)
    }
}
