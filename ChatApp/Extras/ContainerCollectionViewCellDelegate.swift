//
//  ContainerCollectionViewCellDelegate.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public protocol ContainerCollectionViewCellDelegate: AnyObject {
    func prepareForReuse()
    func preferredLayoutAttributesFitting(_ layoutAttributes: ChatLayoutAttributes) -> ChatLayoutAttributes?
    func modifyPreferredLayoutAttributesFitting(_ layoutAttributes: ChatLayoutAttributes)
    func apply(_ layoutAttributes: ChatLayoutAttributes)
}

public extension ContainerCollectionViewCellDelegate {
    func prepareForReuse() {}

    func preferredLayoutAttributesFitting(_ layoutAttributes: ChatLayoutAttributes) -> ChatLayoutAttributes? {
        nil
    }

    func modifyPreferredLayoutAttributesFitting(_ layoutAttributes: ChatLayoutAttributes) {}

    func apply(_ layoutAttributes: ChatLayoutAttributes) {}
}

