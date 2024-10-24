//
//  LayoutAttributes.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public final class ChatLayoutAttributes: UICollectionViewLayoutAttributes {
    public var alignment: ChatItemAlignment = .fullWidth
    public var interItemSpacing: CGFloat = 0
    public internal(set) var additionalInsets: UIEdgeInsets = .zero
    public internal(set) var viewSize: CGSize = .zero
    public internal(set) var adjustedContentInsets: UIEdgeInsets = .zero
    public internal(set) var visibleBoundsSize: CGSize = .zero

    public internal(set) var layoutFrame: CGRect = .zero

    #if DEBUG
    var id: UUID?
    #endif

    convenience init(kind: ItemKind, indexPath: IndexPath = IndexPath(item: 0, section: 0)) {
        switch kind {
        case .cell:
            self.init(forCellWith: indexPath)
        case .header:
            self.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        case .footer:
            self.init(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
        }
    }
    public override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! ChatLayoutAttributes
        copy.viewSize = viewSize
        copy.alignment = alignment
        copy.interItemSpacing = interItemSpacing
        copy.layoutFrame = layoutFrame
        copy.additionalInsets = additionalInsets
        copy.visibleBoundsSize = visibleBoundsSize
        copy.adjustedContentInsets = adjustedContentInsets
        #if DEBUG
        copy.id = id
        #endif
        return copy
    }
    public override func isEqual(_ object: Any?) -> Bool {
        super.isEqual(object)
            && alignment == (object as? ChatLayoutAttributes)?.alignment
            && interItemSpacing == (object as? ChatLayoutAttributes)?.interItemSpacing
    }
    public var kind: ItemKind {
        switch (representedElementCategory, representedElementKind) {
        case (.cell, nil):
            .cell
        case (.supplementaryView, .some(UICollectionView.elementKindSectionHeader)):
            .header
        case (.supplementaryView, .some(UICollectionView.elementKindSectionFooter)):
            .footer
        default:
            preconditionFailure("Unsupported element kind.")
        }
    }

    func typedCopy() -> ChatLayoutAttributes {
        guard let typedCopy = copy() as? ChatLayoutAttributes else {
            fatalError("Internal inconsistency.")
        }
        return typedCopy
    }
}

