//
//  IndexPath++.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation

extension IndexPath {
    var itemPath: ItemPath {
        ItemPath(for: self)
    }
}
