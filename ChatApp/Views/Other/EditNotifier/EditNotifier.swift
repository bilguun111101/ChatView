//
//  EditNotifier.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

final class EditNotifier {
    private(set) var isEditing = false
    private var delegates = NSHashTable<AnyObject>.weakObjects()
    
    func add(delegate : EditNotifierDelegate) {
        delegates.add(delegate)
    }
    
    func setIsEditing(_ isEditing : Bool, duration : ActionDuration) {
        self.isEditing = isEditing
        delegates.allObjects.compactMap {
            $0 as? EditNotifierDelegate
        }.forEach {
            $0.setIsEditing(isEditing, duration: duration)
        }
    }
}
