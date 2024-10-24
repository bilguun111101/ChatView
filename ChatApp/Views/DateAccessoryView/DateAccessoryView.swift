//
//  DateAccessoryView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit
import ChatLayout

final class DateAccessoryView : UIView, ContainerCollectionViewCellDelegate {
    private var accessoryView : UILabel = .init()
        .withoutAutoresizingMaskIntoConstraints
    private var controller : DateAccessoryController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setup(with controller : DateAccessoryController) {
        self.controller = controller
        reloadData()
    }
    
    func reloadData() {
        accessoryView.text = controller?.accessoryText
    }
    
    func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        
        addSubview(accessoryView)
        let constraints : [NSLayoutConstraint] = [
            accessoryView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            accessoryView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            accessoryView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            accessoryView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        accessoryView.font = .preferredFont(forTextStyle: .caption1)
        accessoryView.textColor = .gray
    }
}
