//
//  SwappingContainerView.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public final class SwappingContainerView<CustomView: UIView, AccessoryView: UIView>: UIView {
    public enum Axis: Hashable {
        case horizontal
        case vertical
    }

    public enum Distribution: Hashable {
        case accessoryFirst
        case accessoryLast
    }
    public var distribution: Distribution = .accessoryFirst {
        didSet {
            guard distribution != oldValue else {
                return
            }
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }

    public var axis: Axis = .horizontal {
        didSet {
            guard axis != oldValue else {
                return
            }
            setupContainer()
        }
    }

    public var spacing: CGFloat = 0 {
        didSet {
            guard spacing != oldValue else {
                return
            }
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }

    public var preferredPriority: UILayoutPriority = .required {
        didSet {
            guard preferredPriority != oldValue else {
                return
            }
            setupContainer()
        }
    }

    public var accessoryView: AccessoryView {
        didSet {
            guard accessoryView !== oldValue else {
                return
            }
            if oldValue.superview === self {
                oldValue.removeFromSuperview()
            }
            accessoryFirstObserver?.invalidate()
            accessoryFirstObserver = nil
            setupContainer()
        }
    }

    public var customView: CustomView {
        didSet {
            guard customView !== oldValue else {
                return
            }
            if oldValue.superview === self {
                oldValue.removeFromSuperview()
            }
            customViewObserver?.invalidate()
            customViewObserver = nil
            setupContainer()
        }
    }

    private struct SwappingContainerState: Equatable {
        let axis: Axis

        let distribution: Distribution

        let spacing: CGFloat

        let isAccessoryHidden: Bool

        let isCustomViewHidden: Bool
    }

    private var addedConstraints: [NSLayoutConstraint] = []

    private var accessoryFirstConstraints: [NSLayoutConstraint] = []

    private var accessoryFullConstraints: [NSLayoutConstraint] = []

    private var customViewFirstConstraints: [NSLayoutConstraint] = []

    private var customViewFullConstraints: [NSLayoutConstraint] = []

    private var edgeConstraints: (accessory: [NSLayoutConstraint], customView: [NSLayoutConstraint]) = (accessory: [], customView: [])

    private var cachedState: SwappingContainerState?

    private var accessoryFirstObserver: NSKeyValueObservation?

    private var customViewObserver: NSKeyValueObservation?
    public init(frame: CGRect,
                axis: Axis = .horizontal,
                distribution: Distribution = .accessoryFirst,
                spacing: CGFloat,
                preferredPriority: UILayoutPriority = .required) {
        customView = CustomView(frame: frame)
        accessoryView = AccessoryView(frame: frame)
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
        super.init(frame: frame)
        setupSubviews()
    }

    public override init(frame: CGRect) {
        customView = CustomView(frame: frame)
        accessoryView = AccessoryView(frame: frame)
        super.init(frame: frame)
        setupSubviews()
    }

    @available(*, unavailable, message: "Use init(frame:) instead.")
    public required init?(coder: NSCoder) {
        fatalError("Use init(with:flexibleEdges:) instead.")
    }
    public override class var requiresConstraintBasedLayout: Bool {
        true
    }
    public override func updateConstraints() {
        let currentState = SwappingContainerState(axis: axis,
                                                  distribution: distribution,
                                                  spacing: spacing,
                                                  isAccessoryHidden: accessoryView.isHidden,
                                                  isCustomViewHidden: customView.isHidden)
        guard currentState != cachedState else {
            super.updateConstraints()
            return
        }

        cachedState = currentState

        if currentState.isAccessoryHidden, currentState.isCustomViewHidden {
            NSLayoutConstraint.deactivate(edgeConstraints.accessory)
            NSLayoutConstraint.deactivate(edgeConstraints.customView)
            NSLayoutConstraint.deactivate(accessoryFirstConstraints)
            NSLayoutConstraint.deactivate(customViewFirstConstraints)
            NSLayoutConstraint.deactivate(accessoryFullConstraints)
            NSLayoutConstraint.deactivate(customViewFullConstraints)
        } else if currentState.isAccessoryHidden {
            NSLayoutConstraint.deactivate(edgeConstraints.accessory)
            NSLayoutConstraint.deactivate(accessoryFirstConstraints)
            NSLayoutConstraint.deactivate(customViewFirstConstraints)
            NSLayoutConstraint.deactivate(accessoryFullConstraints)
            NSLayoutConstraint.activate(customViewFullConstraints)
            NSLayoutConstraint.activate(edgeConstraints.customView)
        } else if currentState.isCustomViewHidden {
            NSLayoutConstraint.deactivate(edgeConstraints.customView)
            NSLayoutConstraint.deactivate(accessoryFirstConstraints)
            NSLayoutConstraint.deactivate(customViewFirstConstraints)
            NSLayoutConstraint.deactivate(customViewFullConstraints)
            NSLayoutConstraint.activate(accessoryFullConstraints)
            NSLayoutConstraint.activate(edgeConstraints.accessory)
        } else {
            NSLayoutConstraint.deactivate(accessoryFullConstraints)
            NSLayoutConstraint.deactivate(customViewFullConstraints)

            switch distribution {
            case .accessoryFirst:
                guard !(accessoryFirstConstraints.first?.isActive ?? false) else {
                    accessoryFirstConstraints.first?.constant = -spacing
                    break
                }
                accessoryFirstConstraints.first?.constant = -spacing
                customViewFirstConstraints.first?.constant = spacing
                NSLayoutConstraint.deactivate(customViewFirstConstraints)
                NSLayoutConstraint.activate(accessoryFirstConstraints)
            case .accessoryLast:
                guard !(customViewFirstConstraints.first?.isActive ?? false) else {
                    customViewFirstConstraints.first?.constant = -spacing
                    break
                }
                accessoryFirstConstraints.first?.constant = spacing
                customViewFirstConstraints.first?.constant = -spacing
                NSLayoutConstraint.deactivate(accessoryFirstConstraints)
                NSLayoutConstraint.activate(customViewFirstConstraints)
            }
            NSLayoutConstraint.activate(edgeConstraints.customView)
            NSLayoutConstraint.activate(edgeConstraints.accessory)
        }

        super.updateConstraints()
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        clipsToBounds = false

        setupContainer()
    }

    private func setupContainer() {
        if !addedConstraints.isEmpty {
            NSLayoutConstraint.deactivate(addedConstraints)
            addedConstraints.removeAll()
        }

        if customView.superview != self {
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.removeFromSuperview()
            addSubview(customView)
        }

        if accessoryView.superview != self {
            accessoryView.translatesAutoresizingMaskIntoConstraints = false
            accessoryView.removeFromSuperview()
            addSubview(accessoryView)
        }

        if accessoryFirstObserver == nil {
            accessoryFirstObserver = accessoryView.observe(\.isHidden, options: [.new]) { [weak self] _, _ in
                guard let self else {
                    return
                }
                setNeedsUpdateConstraints()
            }
        }

        if customViewObserver == nil {
            customViewObserver = customView.observe(\.isHidden, options: [.new]) { [weak self] _, _ in
                guard let self else {
                    return
                }
                setNeedsUpdateConstraints()
            }
        }

        cachedState = nil

        let accessoryFirstConstraints = buildAccessoryFirstConstraints()
        let accessoryFullConstraints = buildAccessoryFullConstraints()
        let customViewFirstConstraints = buildCustomViewFirstConstraints()
        let customViewFullConstraints = buildCustomViewFullConstraints()
        let edgeConstraints = buildEdgeConstraints()

        addedConstraints.append(contentsOf: accessoryFirstConstraints)
        addedConstraints.append(contentsOf: accessoryFullConstraints)
        addedConstraints.append(contentsOf: customViewFirstConstraints)
        addedConstraints.append(contentsOf: customViewFullConstraints)
        addedConstraints.append(contentsOf: edgeConstraints.customView)
        addedConstraints.append(contentsOf: edgeConstraints.accessory)

        self.accessoryFirstConstraints = accessoryFirstConstraints
        self.accessoryFullConstraints = accessoryFullConstraints
        self.customViewFirstConstraints = customViewFirstConstraints
        self.customViewFullConstraints = customViewFullConstraints
        self.edgeConstraints = edgeConstraints

        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func spacingPriority() -> UILayoutPriority {
        preferredPriority == .required ? .almostRequired : preferredPriority
    }

    private func buildAccessoryFirstConstraints() -> [NSLayoutConstraint] {
        switch axis {
        case .horizontal:
            [
                accessoryView.trailingAnchor.constraint(equalTo: customView.leadingAnchor, constant: spacing, priority: spacingPriority()),
                accessoryView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
                customView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)
            ]
        case .vertical:
            [
                accessoryView.bottomAnchor.constraint(equalTo: customView.topAnchor, constant: spacing, priority: spacingPriority()),
                accessoryView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
                customView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority)
            ]
        }
    }

    private func buildCustomViewFirstConstraints() -> [NSLayoutConstraint] {
        switch axis {
        case .horizontal:
            [
                customView.trailingAnchor.constraint(equalTo: accessoryView.leadingAnchor, constant: -spacing, priority: spacingPriority()),
                customView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
                accessoryView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)
            ]
        case .vertical:
            [
                customView.bottomAnchor.constraint(equalTo: accessoryView.topAnchor, constant: -spacing, priority: spacingPriority()),
                customView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
                accessoryView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority)
            ]
        }
    }

    private func buildAccessoryFullConstraints() -> [NSLayoutConstraint] {
        switch axis {
        case .horizontal:
            [
                accessoryView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
                accessoryView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)
            ]
        case .vertical:
            [
                accessoryView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
                accessoryView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority)
            ]
        }
    }

    private func buildCustomViewFullConstraints() -> [NSLayoutConstraint] {
        switch axis {
        case .horizontal:
            [
                customView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
                customView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)
            ]
        case .vertical:
            [
                customView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
                customView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority)
            ]
        }
    }

    private func buildEdgeConstraints() -> (accessory: [NSLayoutConstraint], customView: [NSLayoutConstraint]) {
        switch axis {
        case .horizontal:
            (accessory: [accessoryView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
                         accessoryView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority)],
             customView: [customView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
                          customView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority)])
        case .vertical:
            (accessory: [accessoryView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
                         accessoryView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)],
             customView: [customView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
                          customView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)])
        }
    }
}
