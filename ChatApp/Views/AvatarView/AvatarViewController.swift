//
//  AvatarViewController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit

final class AvatarViewController {
//    var image : UIImage? {
//        UIImage()
//    }
    
    private let user : RawUser
    private let bubble : Cell.BubbleType
    
    weak var view : AvatarView? {
        didSet {
            view?.reloadData(with: user.avatar?.medium)
        }
    }
    
    init(user: RawUser, bubble: Cell.BubbleType) {
        self.user = user
        self.bubble = bubble
    }
}
