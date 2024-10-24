//
//  PostMessageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.23.
//

import Foundation
import ChatLayout
import UIKit
import SDWebImage

final class PostMessageView : UIView, ContainerCollectionViewCellDelegate {
    private var viewPortWidth : CGFloat = 300
    private var controller : PostMessageController?
    private lazy var stackView : UIStackView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private var collectionView : UICollectionView!
    private lazy var headerStackView : UIStackView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private lazy var avatarView : SDAnimatedImageView = .init()
        .withoutAutoresizingMaskIntoConstraints
    private lazy var nicknameView : UILabel = .init()
        .withoutAutoresizingMaskIntoConstraints
    private lazy var textView : UITextView = .init()
//        .withoutAutoresizingMaskIntoConstraints
    
    private var stackViewWidthController : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    func setup(with controller : PostMessageController?) {
        self.controller = controller
        reloadData()
    }
    
    func reloadData() {
        guard let controller else {
            return
        }
        UIView.performWithoutAnimation { [weak self] in
            guard let self else {
                return
            }
            avatarView.sd_setImage(with: controller.message.post?.user?.avatar?.url)
            if let nickname = controller.message.post?.user?.nickname {
                nicknameView.text = nickname
//                nicknameView.text = "nickname nickname nickname nickname nickname nickname nickname nickname nickname nickname nickname nickname nickname nickname nickname "
            }
            if let text = controller.message.post?.text {
                textView.text = text
            }
        }
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        
        let customWidth = viewPortWidth * 0.8
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        avatarView.layer.cornerRadius = 12
        avatarView.clipsToBounds = true
        [avatarView, nicknameView].forEach { headerStackView.addArrangedSubview($0) }
        let avatarViewWidth : NSLayoutConstraint = avatarView.widthAnchor.constraint(equalToConstant: 28)
        avatarViewWidth.isActive = true
        avatarViewWidth.priority = .init(rawValue: 999)
        let avatarViewHeight : NSLayoutConstraint = avatarView.heightAnchor.constraint(equalToConstant: 28)
        avatarViewHeight.isActive = true
        avatarViewHeight.priority = .init(rawValue: 999)
        headerStackView.alignment = .center
        headerStackView.spacing = 8
        
        nicknameView.font = .systemFont(ofSize: 12, weight: .bold)
        nicknameView.textColor = .black
        nicknameView.numberOfLines = 1
        
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.spellCheckingType = .no
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.dataDetectorTypes = .all
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.scrollsToTop = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isExclusiveTouch = true
        
        backgroundColor = .systemGray5
        
        stackView.addArrangedSubview(headerStackView)
        
        NSLayoutConstraint.activate([
            headerStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            headerStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
        ])
        
        let headerStackViewHeight : NSLayoutConstraint = headerStackView.heightAnchor.constraint(equalToConstant: 44)
        headerStackViewHeight.isActive = true
        headerStackViewHeight.priority = .init(rawValue: 999)
        
        let headerStackViewWidth : NSLayoutConstraint = headerStackView.heightAnchor.constraint(equalTo: stackView.widthAnchor)
        headerStackViewWidth.isActive = true
        headerStackViewWidth.priority = .init(rawValue: 999)
        
        let layout : UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = .init(width: customWidth, height: customWidth)
        
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
            .withoutAutoresizingMaskIntoConstraints
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ImageView.self, forCellWithReuseIdentifier: "ImageView")
        collectionView.selfSizingInvalidation = .enabled
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.isEditing = false
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        stackView.addArrangedSubview(collectionView)
        
        let carouselWidth : NSLayoutConstraint = collectionView.widthAnchor.constraint(equalToConstant: customWidth)
        carouselWidth.isActive = true
        carouselWidth.priority = .init(rawValue: 999)
        
        let carouselHeight : NSLayoutConstraint = collectionView.heightAnchor.constraint(equalToConstant: customWidth)
        carouselHeight.isActive = true
        carouselHeight.priority = .init(rawValue: 999)
        
        stackView.addArrangedSubview(textView)
        
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .leading
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
        
        let stackViewWidth : NSLayoutConstraint = stackView.widthAnchor.constraint(equalToConstant: viewPortWidth)
        stackViewWidth.isActive = true
        stackViewWidth.priority = .init(rawValue: 999)
    }
}

extension PostMessageView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controller?.message.post?.contents.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath) as? ImageView,
              let data = controller?.message.post?.contents[indexPath.item] else {
            return .init()
        }
        cell.setup(with: data.thumbnail)
        return cell
    }

}

extension PostMessageView : UICollectionViewDelegate { }
