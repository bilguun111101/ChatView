//
//  GroupInfoController.swift
//  ChatApp
//
//  Created by qq on 2024.10.20.
//

import Foundation
import UIKit

final class GroupInfoController {
    weak var view : GroupInfoView? {
        didSet {
            view?.reloadData()
        }
    }
    
    let message : RawMessage
    let type : MessageType
    
    init(message: RawMessage, type : MessageType) {
        self.message = message
        self.type = type
    }
}
