//
//  DateFormatter.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

public final class ChatDateFormatter {
    public static let shared = ChatDateFormatter()
    private let formatter = DateFormatter()
    
    private init() {}
    
    public func string(from date : Date) -> String {
        configureDateFormatter(for: date)
        return formatter.string(from: date)
    }
    
    public func attributedString(from date : Date, with attributes : [NSAttributedString.Key : Any]) -> NSAttributedString {
        let dateString = string(from: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }
    
    func configureDateFormatter(for date : Date) {
        switch true {
        case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .short
            formatter.timeStyle = .short
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            formatter.dateFormat = "EEEE hh:mm"
        default:
            formatter.dateFormat = "MMM d, yyyy, hh:mm"
        }
    }
}

public final class MessageDateFormatter {
    public static let shared = MessageDateFormatter()
    private let formatter = DateFormatter()
    
    private init() {
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .none
        formatter.timeStyle = .short
    }
    
    public func string(from date : Date) -> String {
        formatter.string(from: date)
    }
    
    public func attributedString(from date : Date, with attributes : [NSAttributedString.Key : Any]) -> NSAttributedString {
        let dateString = string(from: date)
        return NSAttributedString(string: dateString, attributes: attributes)
    }
}
