//
//  ItemPath.swift
//  ChatApp
//
//  Created by qq on 2024.10.24.
//

import Foundation

struct ItemPath: Hashable {
    let section: Int

    let item: Int

    var indexPath: IndexPath {
        IndexPath(item: item, section: section)
    }

    init(item: Int, section: Int) {
        self.section = section
        self.item = item
    }

    init(for indexPath: IndexPath) {
        section = indexPath.section
        item = indexPath.item
    }
}
