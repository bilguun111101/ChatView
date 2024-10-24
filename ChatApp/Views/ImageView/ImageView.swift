//
//  ImageView.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit
import SDWebImage

final class ImageView : UICollectionViewCell {
    public static var reuseIdentifier: String {
        String(describing: self)
    }
    
    private lazy var imageView : SDAnimatedImageView = .init()
        .withoutAutoresizingMaskIntoConstraints
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    func setup(with url : URL?) {
        imageView.sd_setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupSubviews() {
        backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFill
        contentView.clipsToBounds = true
        clipsToBounds = true
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
