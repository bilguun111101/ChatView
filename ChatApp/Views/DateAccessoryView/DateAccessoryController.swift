//
//  DateAccessoryController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

final class DateAccessoryController {
    weak var view : DateAccessoryView? {
        didSet {
            view?.reloadData()
        }
    }
    
    private let date : Date
    let accessoryText : String
    
    init(date: Date) {
        self.date = date
        self.accessoryText = MessageDateFormatter.shared.string(from: date)
    }
}
