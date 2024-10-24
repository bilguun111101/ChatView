//
//  NSLayoutDimension++.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

extension NSLayoutDimension {
    @objc
    func constraint(equalTo anchor: NSLayoutDimension,
                    multiplier m: CGFloat = 1,
                    constant c: CGFloat = 0,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(greaterThanOrEqualTo anchor: NSLayoutDimension,
                    multiplier m: CGFloat = 1,
                    constant c: CGFloat = 0,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(lessThanOrEqualTo anchor: NSLayoutDimension,
                    multiplier m: CGFloat = 1,
                    constant c: CGFloat = 0,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(lessThanOrEqualTo: anchor, multiplier: m, constant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(equalToConstant c: CGFloat,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(equalToConstant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(greaterThanOrEqualToConstant c: CGFloat,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualToConstant: c)
        constraint.priority = priority
        return constraint
    }

    @objc
    func constraint(lessThanOrEqualToConstant c: CGFloat,
                    priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(lessThanOrEqualToConstant: c)
        constraint.priority = priority
        return constraint
    }
}
