//
//  ContainerCollectionViewCell.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public final class ContainerCollectionViewCell<CustomView: UIView>: UICollectionViewCell {
    public static var reuseIdentifier: String {
        String(describing: self)
    }
    public lazy var customView = CustomView(frame: bounds)
    public weak var delegate: ContainerCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    @available(*, unavailable, message: "Use init(reuseIdentifier:) instead.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        delegate?.prepareForReuse()
    }

    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let chatLayoutAttributes = layoutAttributes as? ChatLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        delegate?.apply(chatLayoutAttributes)
        let resultingLayoutAttributes: ChatLayoutAttributes
        if let preferredLayoutAttributes = delegate?.preferredLayoutAttributesFitting(chatLayoutAttributes) {
            resultingLayoutAttributes = preferredLayoutAttributes
        } else if let chatLayoutAttributes = super.preferredLayoutAttributesFitting(chatLayoutAttributes) as? ChatLayoutAttributes {
            delegate?.modifyPreferredLayoutAttributesFitting(chatLayoutAttributes)
            resultingLayoutAttributes = chatLayoutAttributes
        } else {
            resultingLayoutAttributes = chatLayoutAttributes
        }
        return resultingLayoutAttributes
    }

    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let chatLayoutAttributes = layoutAttributes as? ChatLayoutAttributes else {
            return
        }
        super.apply(layoutAttributes)
        delegate?.apply(chatLayoutAttributes)
    }

    private func setupSubviews() {
        contentView.addSubview(customView)
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero

        contentView.insetsLayoutMarginsFromSafeArea = false
        contentView.layoutMargins = .zero

        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            customView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
