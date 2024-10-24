//
//  CallMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit
import ChatLayout

final class CallMessageView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 300
    private var controller : CallMessageController?
    private lazy var stackView : UIStackView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private var callViewWidthConstraint : NSLayoutConstraint?
    private lazy var imageView : UIImageView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private lazy var titleLabel : UILabel = .init()
    private lazy var statusLabel : UILabel = .init()
    
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
    
    func setup(with controller : CallMessageController?) {
        self.controller = controller
        reloadData()
    }
    
    func reloadData() {
        guard let controller else {
            return
        }
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        
        let verticalView : UIStackView = .init()
        verticalView.axis = .vertical
        verticalView.alignment = .leading
        verticalView.spacing = 3
        
        titleLabel.text = "Дуудлага"
        titleLabel.textColor = .black
        titleLabel.font = .monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
        
        statusLabel.text = "15 секунд"
        statusLabel.textColor = .gray
        statusLabel.font = .systemFont(ofSize: 11, weight: .regular)
        
        [titleLabel, statusLabel].forEach { verticalView.addArrangedSubview($0) }
        
        let iconView : UIView = .init()
            .withoutAutoresizingMaskIntoConstraints
        iconView.backgroundColor = .gray
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 25
        imageView.tintColor = .white
        let configuration = UIImage.SymbolConfiguration(pointSize: 20)
        imageView.image = UIImage(systemName: "video", withConfiguration: configuration)?
            .withTintColor(.white)
        imageView.contentMode = .scaleAspectFit
        iconView.addSubview(imageView)
        [iconView, verticalView, UIView()].forEach { stackView.addArrangedSubview($0) }
        
        let iconViewWidthContraints : NSLayoutConstraint = iconView.widthAnchor.constraint(equalToConstant: 50)
        iconViewWidthContraints.isActive = true
        iconViewWidthContraints.priority = .init(rawValue: 999)
        
        let iconViewHeightContraints : NSLayoutConstraint = iconView.heightAnchor.constraint(equalToConstant: 50)
        iconViewHeightContraints.isActive = true
        iconViewHeightContraints.priority = .init(rawValue: 999)
        
        NSLayoutConstraint.activate([
//            iconView.widthAnchor.constraint(equalToConstant: 50),
//            iconView.heightAnchor.constraint(equalToConstant: 50),
            imageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 30),
//            imageView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        addSubview(stackView)
        let constraints : [NSLayoutConstraint] = [
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
