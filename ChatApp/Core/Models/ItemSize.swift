//
//  ItemSize.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public enum ItemSize: Hashable {
    case auto
    case estimated(CGSize)
    case exact(CGSize)

    public enum CaseType: Hashable, CaseIterable {
        case auto
        case estimated
        case exact
    }

    public var caseType: CaseType {
        switch self {
        case .auto:
            .auto
        case .estimated:
            .estimated
        case .exact:
            .exact
        }
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(caseType)
        switch self {
        case .auto:
            break
        case let .estimated(size):
            hasher.combine(size.width)
            hasher.combine(size.height)
        case let .exact(size):
            hasher.combine(size.width)
            hasher.combine(size.height)
        }
    }
}
