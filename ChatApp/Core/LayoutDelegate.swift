//
//  LayoutDelegate.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public enum InitialAttributesRequestType: Hashable {
    case initial
    case invalidation
}

public protocol ChatLayoutDelegate: AnyObject {
    func shouldPresentHeader(_ chatLayout: CollectionViewChatLayout,
                             at sectionIndex: Int) -> Bool

    func shouldPresentFooter(_ chatLayout: CollectionViewChatLayout,
                             at sectionIndex: Int) -> Bool

    func sizeForItem(_ chatLayout: CollectionViewChatLayout,
                     of kind: ItemKind,
                     at indexPath: IndexPath) -> ItemSize

    func alignmentForItem(_ chatLayout: CollectionViewChatLayout,
                          of kind: ItemKind,
                          at indexPath: IndexPath) -> ChatItemAlignment

    func initialLayoutAttributesForInsertedItem(_ chatLayout: CollectionViewChatLayout,
                                                of kind: ItemKind,
                                                at indexPath: IndexPath,
                                                modifying originalAttributes: ChatLayoutAttributes,
                                                on state: InitialAttributesRequestType)

    func finalLayoutAttributesForDeletedItem(_ chatLayout: CollectionViewChatLayout,
                                             of kind: ItemKind,
                                             at indexPath: IndexPath,
                                             modifying originalAttributes: ChatLayoutAttributes)

    func interItemSpacing(_ chatLayout: CollectionViewChatLayout,
                          of kind: ItemKind,
                          after indexPath: IndexPath) -> CGFloat?

    func interSectionSpacing(_ chatLayout: CollectionViewChatLayout,
                             after sectionIndex: Int) -> CGFloat?
}

public extension ChatLayoutDelegate {
    func shouldPresentHeader(_ chatLayout: CollectionViewChatLayout,
                             at sectionIndex: Int) -> Bool {
        false
    }

    func shouldPresentFooter(_ chatLayout: CollectionViewChatLayout,
                             at sectionIndex: Int) -> Bool {
        false
    }

    func sizeForItem(_ chatLayout: CollectionViewChatLayout,
                     of kind: ItemKind,
                     at indexPath: IndexPath) -> ItemSize {
        .auto
    }

    func alignmentForItem(_ chatLayout: CollectionViewChatLayout,
                          of kind: ItemKind,
                          at indexPath: IndexPath) -> ChatItemAlignment {
        .fullWidth
    }

    func initialLayoutAttributesForInsertedItem(_ chatLayout: CollectionViewChatLayout,
                                                of kind: ItemKind,
                                                at indexPath: IndexPath,
                                                modifying originalAttributes: ChatLayoutAttributes,
                                                on state: InitialAttributesRequestType) {
        originalAttributes.alpha = 0
    }

    func finalLayoutAttributesForDeletedItem(_ chatLayout: CollectionViewChatLayout,
                                             of kind: ItemKind,
                                             at indexPath: IndexPath,
                                             modifying originalAttributes: ChatLayoutAttributes) {
        originalAttributes.alpha = 0
    }

    func interItemSpacing(_ chatLayout: CollectionViewChatLayout,
                          of kind: ItemKind,
                          after indexPath: IndexPath) -> CGFloat? {
        nil
    }

    func interSectionSpacing(_ chatLayout: CollectionViewChatLayout,
                             after sectionIndex: Int) -> CGFloat? {
        nil
    }
}
