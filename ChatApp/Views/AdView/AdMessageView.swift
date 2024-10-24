//
//  AdMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.21.
//

import Foundation
import UIKit
import ChatLayout

final class AdMessageView : UIView, ContainerCollectionViewCellDelegate {
    private lazy var viewPortWidth : CGFloat = 300
    private lazy var stackView : UIStackView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private var imageView : UIImageView!
    private var descriptionText : UILabel!
    private var priceText : UILabel!
    private var statusText : UILabel!
    private var categoryStackView : UIStackView!
    private var controller : AdMessageController?
    private var adViewWidthContraint : NSLayoutConstraint?
    
    func reloadData() {
        guard let controller else {
            return
        }
    }
    
    func setup(with controller : AdMessageController?) {
        self.controller = controller
        reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSize(with view : UIView) {
//        if let widthAnchor = view.superview?.widthAnchor {
//            view.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
//        }
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        insetsLayoutMarginsFromSafeArea = false
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView = .init()
            .withoutAutoresizingMaskIntoConstraints
        imageView.sd_setImage(with: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEF7EUkgNAJDYYeBcQAdR1KyPZeAmM_9ENqA&s"))
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        descriptionText = .init()
            .withoutAutoresizingMaskIntoConstraints
        priceText = .init()
            .withoutAutoresizingMaskIntoConstraints
        statusText = .init()
            .withoutAutoresizingMaskIntoConstraints
        categoryStackView = .init()
            .withoutAutoresizingMaskIntoConstraints
        
        descriptionText.text = "Tiny home hosted by Jeremy & Erle"
        descriptionText.font = .preferredFont(forTextStyle: .body)
        descriptionText.textColor = .black
        
        priceText.text = "$ 379,000.00"
        priceText.font = .systemFont(ofSize: 15, weight: .semibold)
        priceText.textColor = .black
        
        statusText.text = "Sale"
        statusText.textColor = .gray
        statusText.font = .systemFont(ofSize: 14, weight: .regular)
        
        let views : [UIView] = [imageView, categoryStackView, descriptionText, priceText, statusText]
        views.forEach {
            stackView.addArrangedSubview($0)
            setupSize(with: $0)
        }
        let categoryLeadingContraint : NSLayoutConstraint = categoryStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        categoryLeadingContraint.isActive = true
        categoryLeadingContraint.priority = .init(rawValue: 999)
        
        let imageViewWidthContraint : NSLayoutConstraint = imageView.heightAnchor.constraint(equalToConstant: 216)
        imageViewWidthContraint.isActive = true
        imageViewWidthContraint.priority = .init(rawValue: 999)
        
        backgroundColor = .systemGray5
        
        stackView.axis = .vertical
        stackView.spacing = 10
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
        
        adViewWidthContraint = stackView.widthAnchor.constraint(lessThanOrEqualToConstant: viewPortWidth)
        adViewWidthContraint?.isActive = true
        adViewWidthContraint?.priority = .init(rawValue: 999)
    }
}
