//
//  ImageMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit
import ChatLayout

final class ImageMessageView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 300
    private var controller : ImageMessageController?
    private var imageWidthConstraint : NSLayoutConstraint?
    private var imageHeightConstraint : NSLayoutConstraint?
    private var layout : UICollectionViewFlowLayout = .init()
//    private lazy var imageView : UIImageView = .init(frame: bounds)
//        .withoutAutoresizingMaskIntoConstraints
    
    private lazy var stackView : UIStackView = .init(frame: bounds)
        .withoutAutoresizingMaskIntoConstraints
    
    private var collectionView : UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    func setup(with controller : ImageMessageController?) {
        self.controller = controller
    }

    func reloadData() {
        guard let controller else {
             return
        }
        UIView.performWithoutAnimation { [weak self] in
            guard let self,
                  let images = controller.message.images
            else {
                return
            }
            
            var imageSize : CGSize!
            let length = (controller.message.images?.count ?? 0)
            let customMaxWidth = viewPortWidth * Constants.maxWidth
            switch true {
            case length == 1:
                let imageData = images[0]
                
                let width = min(CGFloat(imageData.width), customMaxWidth)
                let multiplier = CGFloat(imageData.height) / CGFloat(imageData.width)
                imageSize = .init(width: width, height: width * multiplier)
                imageHeightConstraint?.isActive = true
                imageWidthConstraint?.isActive = true
                imageHeightConstraint?.constant = imageSize.height
                setNeedsLayout()
            case length == 2:
                let size = (customMaxWidth / 2) - 0.5
                imageSize = .init(width: size, height: size)
                imageHeightConstraint?.isActive = true
                imageWidthConstraint?.isActive = true
                imageHeightConstraint?.constant = customMaxWidth
                setNeedsLayout()
            case length > 2 && length < 5:
                let size = (customMaxWidth / 2) - 0.5
                imageSize = .init(width: size, height: size)
                imageHeightConstraint?.isActive = true
                imageWidthConstraint?.isActive = true
                imageHeightConstraint?.constant = customMaxWidth
                setNeedsLayout()
            case length > 4 && length < 10:
                let size = (customMaxWidth / 3) - (2 / 3)
                imageSize = .init(width: size, height: size)
                imageHeightConstraint?.isActive = true
                imageWidthConstraint?.isActive = true
                imageHeightConstraint?.constant = customMaxWidth
                setNeedsLayout()
            case length == 10:
                let size = (customMaxWidth / 3) - (2 / 3)
                imageSize = .init(width: size, height: size)
                imageHeightConstraint?.isActive = true
                imageWidthConstraint?.isActive = true
                imageHeightConstraint?.constant = customMaxWidth
                setNeedsLayout()
            default:
                imageSize = .init(
                    width: customMaxWidth, height: customMaxWidth
                )
                imageHeightConstraint?.isActive = true
                imageWidthConstraint?.isActive = true
                imageHeightConstraint?.constant = customMaxWidth
                setNeedsLayout()
            }
            layout.itemSize = imageSize
            if length > 1 {
                layout.minimumLineSpacing = 1
                layout.minimumInteritemSpacing = 1
            }
            
            stackView.addArrangedSubview(collectionView)
            collectionView.reloadData()
            collectionView.setNeedsLayout()
            collectionView.layoutIfNeeded()
            stackView.setNeedsLayout()
            stackView.layoutIfNeeded()
        }
    }
    
    func prepareForReuse() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        collectionView = .init(frame: bounds, collectionViewLayout: layout)
            .withoutAutoresizingMaskIntoConstraints
        
        imageWidthConstraint = collectionView.widthAnchor.constraint(equalToConstant: viewPortWidth * Constants.maxWidth)
        imageWidthConstraint?.priority = .init(rawValue: 999)
        
        imageHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: viewPortWidth * Constants.maxWidth)
        imageHeightConstraint?.priority = .init(rawValue: 999)
        
        imageWidthConstraint?.isActive = false
        imageHeightConstraint?.isActive = false
        
        collectionView.register(ImageView.self, forCellWithReuseIdentifier: ImageView.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isPrefetchingEnabled = false
        collectionView.selfSizingInvalidation = .enabled
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.register(ImageView.self, forCellWithReuseIdentifier: ImageView.reuseIdentifier)
        
        collectionView.dataSource = self
        
//        layout = .init()
//        
//        collectionView = .init(frame: .zero, collectionViewLayout: layout)
//            .withoutAutoresizingMaskIntoConstraints
//        
//        addSubview(collectionView)
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
//        ])
//        
//        imageWidthConstraint = collectionView.widthAnchor.constraint(
//            equalToConstant: viewPortWidth * Constants.maxWidth
//        )
////        imageHeightConstraint = collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor)
////        imageHeightConstraint?.priority = .init(rawValue: 999)
////        imageHeightConstraint?.isActive = true
//        
//        imageWidthConstraint?.priority = .init(rawValue: 999)
//        imageWidthConstraint?.isActive = true
//        setNeedsLayout()
    }
}

extension ImageMessageView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = controller?.message.images?.count else {
            return 0
        }
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = controller?.message.images?[indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath) as? ImageView
        else {
            return .init()
        }
        cell.setup(with: data.url)
        return cell
    }
}
