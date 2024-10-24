//
//  EditingAccessoryController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit

protocol EditingAccessoryControllerDelegate : AnyObject {
    func deleteMessage(with _id : String)
}

final class EditingAccessoryController {
    weak var delegate : EditingAccessoryControllerDelegate?
    weak var view : EditingAccessoryView?
    
    private let messageID : String
    
    init(messageID: String) {
        self.messageID = messageID
    }
    
    func deleteButtonTapped() {
        delegate?.deleteMessage(with: messageID)
    }
}
