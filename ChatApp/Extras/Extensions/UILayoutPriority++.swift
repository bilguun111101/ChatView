//
//  UILayoutPriority++.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

extension UILayoutPriority {
    static let almostRequired = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
}
