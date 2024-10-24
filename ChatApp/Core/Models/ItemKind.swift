//
//  ItemKind.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public enum ItemKind: CaseIterable, Hashable {
    case header
    case cell
    case footer

    init(_ elementKind: String) {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            self = .header
        case UICollectionView.elementKindSectionFooter:
            self = .footer
        default:
            preconditionFailure("Unsupported supplementary view kind.")
        }
    }

    public var isSupplementaryItem: Bool {
        switch self {
        case .cell:
            false
        case .footer,
             .header:
            true
        }
    }

    var supplementaryElementStringType: String {
        switch self {
        case .cell:
            preconditionFailure("Cell type is not a supplementary view.")
        case .header:
            UICollectionView.elementKindSectionHeader
        case .footer:
            UICollectionView.elementKindSectionFooter
        }
    }
}
