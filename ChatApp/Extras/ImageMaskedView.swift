//
//  ImageMaskedView.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public enum ImageMaskedViewTransformation {
    case asIs
    case flippedVertically
}

public final class ImageMaskedView<CustomView: UIView>: UIView {
    public lazy var customView = CustomView(frame: bounds)
    public var maskingImage: UIImage? {
        didSet {
            setupMask()
        }
    }

    public var maskTransformation: ImageMaskedViewTransformation = .asIs {
        didSet {
            guard oldValue != maskTransformation else {
                return
            }
            updateMask()
        }
    }

    private lazy var imageView = UIImageView(frame: bounds)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    private func setupSubviews() {
        layoutMargins = .zero
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false

        addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            customView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            customView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupMask() {
        guard let bubbleImage = maskingImage else {
            imageView.image = nil
            mask = nil
            return
        }

        imageView.image = bubbleImage
        mask = imageView
        updateMask()
    }

    private func updateMask() {
        UIView.performWithoutAnimation {
            let multiplier = effectiveUserInterfaceLayoutDirection == .leftToRight ? 1 : -1
            switch maskTransformation {
            case .flippedVertically:
                imageView.transform = CGAffineTransform(scaleX: CGFloat(multiplier * -1), y: 1)
            case .asIs:
                imageView.transform = CGAffineTransform(scaleX: CGFloat(multiplier * 1), y: 1)
            }
        }
    }
    public override final var frame: CGRect {
        didSet {
            imageView.frame = bounds
        }
    }
    public override final var bounds: CGRect {
        didSet {
            imageView.frame = bounds
        }
    }
}
