//
//  LayoutPositionSnapshot.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public struct ChatLayoutPositionSnapshot: Hashable {
    public enum Edge: Hashable {
        case top
        case bottom
    }

    public var indexPath: IndexPath
    public var kind: ItemKind
    public var edge: Edge
    public var offset: CGFloat

    public init(indexPath: IndexPath,
                kind: ItemKind,
                edge: Edge,
                offset: CGFloat = 0) {
        self.indexPath = indexPath
        self.edge = edge
        self.offset = offset
        self.kind = kind
    }
}
