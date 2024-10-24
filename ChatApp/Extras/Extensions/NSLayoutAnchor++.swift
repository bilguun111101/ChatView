//
//  NSLayoutAnchor++.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

extension NSLayoutAnchor {
    @objc
    func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>,
                    constant c: CGFloat = 0,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor, constant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(greaterThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>,
                    constant c: CGFloat = 0,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, constant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(lessThanOrEqualTo anchor: NSLayoutAnchor<AnchorType>,
                    constant c: CGFloat = 0,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(lessThanOrEqualTo: anchor, constant: c)
        constraint.priority = priority
        return constraint
    }
}
