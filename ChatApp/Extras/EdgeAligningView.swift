//
//  EdgeAligningView.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public final class EdgeAligningView<CustomView: UIView>: UIView {
    public enum Edge: CaseIterable {
        case top
        case leading
        case trailing
        case bottom
    }

    public var flexibleEdges: Set<Edge> = [] {
        didSet {
            guard flexibleEdges != oldValue else {
                return
            }
            lastConstraintsUpdateEdges = nil
            setNeedsUpdateConstraints()
            setNeedsLayout()
        }
    }

    public var customView: CustomView {
        didSet {
            guard customView !== oldValue else {
                return
            }
            oldValue.removeFromSuperview()
            setupContainer()
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

    private var rigidConstraints: [Edge: NSLayoutConstraint] = [:]

    private var flexibleConstraints: [Edge: NSLayoutConstraint] = [:]

    private var centerConstraints: (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint)?

    private var addedConstraints: [NSLayoutConstraint] = []

    private var lastConstraintsUpdateEdges: Set<Edge>?

    public init(with customView: CustomView,
                flexibleEdges: Set<Edge> = [.top],
                preferredPriority: UILayoutPriority = .required) {
        self.customView = customView
        self.flexibleEdges = flexibleEdges
        self.preferredPriority = preferredPriority
        super.init(frame: customView.frame)
        setupContainer()
    }

    public override init(frame: CGRect) {
        customView = CustomView(frame: frame)
        super.init(frame: frame)
        setupSubviews()
    }

    public init(frame: CGRect,
                flexibleEdges: Set<Edge> = [],
                preferredPriority: UILayoutPriority = .required) {
        customView = CustomView(frame: frame)
        self.flexibleEdges = flexibleEdges
        self.preferredPriority = preferredPriority
        super.init(frame: frame)
        setupSubviews()
    }

    @available(*, unavailable, message: "Use init(with:flexibleEdges:) instead.")
    public required init?(coder: NSCoder) {
        fatalError("Use init(with:flexibleEdges:) instead.")
    }
    public override class var requiresConstraintBasedLayout: Bool {
        true
    }
    public override func updateConstraints() {
        guard lastConstraintsUpdateEdges != flexibleEdges else {
            super.updateConstraints()
            return
        }

        for edge in flexibleEdges {
            rigidConstraints[edge]?.isActive = false
            flexibleConstraints[edge]?.isActive = true
        }
        for edge in Set(Edge.allCases).subtracting(flexibleEdges) {
            flexibleConstraints[edge]?.isActive = false
            rigidConstraints[edge]?.isActive = true
        }
        centerConstraints?.centerX.isActive = flexibleEdges.contains(.leading) && flexibleEdges.contains(.trailing)
        centerConstraints?.centerY.isActive = flexibleEdges.contains(.top) && flexibleEdges.contains(.bottom)

        lastConstraintsUpdateEdges = flexibleEdges

        super.updateConstraints()
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        insetsLayoutMarginsFromSafeArea = false
        layoutMargins = .zero
        setupContainer()
    }

    private func setupContainer() {
        if customView.superview != self {
            customView.removeFromSuperview()
            addSubview(customView)
        }
        customView.translatesAutoresizingMaskIntoConstraints = false
        if !addedConstraints.isEmpty {
            NSLayoutConstraint.deactivate(addedConstraints)
            addedConstraints.removeAll()
        }

        lastConstraintsUpdateEdges = nil

        let rigidConstraints = buildRigidConstraints(customView)
        let flexibleConstraints = buildFlexibleConstraints(customView)
        let centerConstraints = buildCenterConstraints(customView)

        addedConstraints.append(contentsOf: rigidConstraints.values)
        addedConstraints.append(contentsOf: flexibleConstraints.values)
        addedConstraints.append(centerConstraints.centerX)
        addedConstraints.append(centerConstraints.centerY)

        self.rigidConstraints = rigidConstraints
        self.flexibleConstraints = flexibleConstraints
        self.centerConstraints = centerConstraints
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func buildCenterConstraints(_ view: UIView) -> (centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
        (centerX: view.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor, priority: preferredPriority),
         centerY: view.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor, priority: preferredPriority))
    }

    private func buildRigidConstraints(_ view: UIView) -> [Edge: NSLayoutConstraint] {
        [.top: view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
         .bottom: view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority),
         .leading: view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
         .trailing: view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)]
    }

    private func buildFlexibleConstraints(_ view: UIView) -> [Edge: NSLayoutConstraint] {
        [.top: view.topAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.topAnchor, priority: preferredPriority),
         .bottom: view.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor, priority: preferredPriority),
         .leading: view.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor, priority: preferredPriority),
         .trailing: view.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor, priority: preferredPriority)]
    }
}
