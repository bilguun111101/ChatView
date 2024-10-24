//
//  CellLayoutContainerView.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public enum CellLayoutContainerViewAlignment {
    case fill
    case top
    case center
    case bottom

    fileprivate var stackAlignment: UIStackView.Alignment {
        switch self {
        case .fill: .fill
        case .top: .top
        case .center: .center
        case .bottom: .bottom
        }
    }
}

public final class CellLayoutContainerView<LeadingAccessory: StaticViewFactory, CustomView: UIView, TrailingAccessory: StaticViewFactory>: UIView {
    public lazy var leadingView: LeadingAccessory.View? = LeadingAccessory.buildView(within: bounds)
    
    public lazy var customView = CustomView(frame: bounds)
    public lazy var trailingView: TrailingAccessory.View? = TrailingAccessory.buildView(within: bounds)


    public var alignment: CellLayoutContainerViewAlignment = .center {
        didSet {
            stackView.alignment = alignment.stackAlignment
        }
    }

    public var spacing: CGFloat {
        get {
            stackView.spacing
        }
        set {
            stackView.spacing = newValue
        }
    }

    public var customLeadingSpacing: CGFloat {
        get {
            guard let leadingView else {
                return 0
            }
            return stackView.customSpacing(after: leadingView)
        }
        set {
            guard let leadingView else {
                return
            }
            return stackView.setCustomSpacing(newValue, after: leadingView)
        }
    }

    public var customTrailingSpacing: CGFloat {
        get {
            stackView.customSpacing(after: customView)
        }
        set {
            stackView.setCustomSpacing(newValue, after: customView)
        }
    }

    private let stackView = UIStackView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero

        stackView.axis = .horizontal
        stackView.alignment = alignment.stackAlignment
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])

        if let leadingAccessoryView = leadingView {
            stackView.addArrangedSubview(leadingAccessoryView)
            leadingAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        }

        stackView.addArrangedSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false

        if let trailingAccessoryView = trailingView {
            stackView.addArrangedSubview(trailingAccessoryView)
            trailingAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}
