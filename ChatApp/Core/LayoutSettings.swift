//
//  LayoutSettings.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public struct ChatLayoutSettings: Equatable {
    public var estimatedItemSize: CGSize?
    public var interItemSpacing: CGFloat = 0
    public var interSectionSpacing: CGFloat = 0
    public var additionalInsets: UIEdgeInsets = .zero
}
