//
//  ChatCollectionDataSource.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit

protocol ChatCollectionDataSource : UICollectionViewDataSource, ChatLayoutDelegate {
    var sections : [Section] { get set }
    
    func prepare(with collectionView : UICollectionView)
}
