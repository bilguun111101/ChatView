//
//  AvatarView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit
import SDWebImage

protocol AvatarViewDelegate : AnyObject {
    func avatarTapped()
}

final class AvatarView : UIView, StaticViewFactory {
    weak var delegate : AvatarViewDelegate?
    
    private lazy var circleImageView = RoundedCornersContainerView<UIImageView>(frame: bounds)
        .withoutAutoresizingMaskIntoConstraints
    private var controller : AvatarViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        circleImageView.customView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        backgroundColor = .black
    }
    
    func reloadData(with url : URL?) {
        guard let controller else {
            return
        }
        UIView.performWithoutAnimation {
            circleImageView.customView.sd_setImage(with: url)
        }
    }
    
    func setup(with controller : AvatarViewController) {
        self.controller = controller
    }
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        addSubview(circleImageView)
        
        let constraints : [NSLayoutConstraint] = [
            circleImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            circleImageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            circleImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        let constraint = circleImageView.widthAnchor.constraint(equalToConstant: 30)
        constraint.priority = .init(rawValue: 999)
        constraint.isActive = true
        circleImageView.heightAnchor.constraint(equalTo: circleImageView.widthAnchor, multiplier: 1).isActive = true
        
        circleImageView.customView.contentMode = .scaleAspectFill
        
        let gestureRecognizer : UITapGestureRecognizer = .init()
        circleImageView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(avatarTapped))
    }
    
    @objc func avatarTapped() {
        delegate?.avatarTapped()
    }
}
