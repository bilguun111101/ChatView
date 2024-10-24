//
//  StaticViewFactory.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation
import UIKit

public protocol StaticViewFactory {
    associatedtype View: UIView
    static func buildView(within bounds: CGRect) -> View?
}

public extension StaticViewFactory where Self: UIView {
    static func buildView(within bounds: CGRect) -> Self? {
        Self(frame: bounds)
    }
}

public struct VoidViewFactory: StaticViewFactory {
    public final class VoidView: UIView {
        @available(*, unavailable, message: "This view can not be instantiated.")
        public required init?(coder aDecoder: NSCoder) {
            fatalError("This view can not be instantiated.")
        }

        @available(*, unavailable, message: "This view can not be instantiated.")
        public override init(frame: CGRect) {
            fatalError("This view can not be instantiated.")
        }

        @available(*, unavailable, message: "This view can not be instantiated.")
        public init() {
            fatalError("This view can not be instantiated.")
        }
    }

    public static func buildView(within bounds: CGRect) -> VoidView? {
        nil
    }
}
