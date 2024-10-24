//
//  Section.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import DifferenceKit

struct Section : Hashable {
    var id : Int
    var date : Date
    var messages : [Cell]
}

extension Section : DifferentiableSection {
    
    public init<C: Swift.Collection>(source: Section, elements: C) where C.Element == Cell {
        self.init(id: source.id, date: source.date, messages: Array(elements))
    }
    
    func isContentEqual(to source: Section) -> Bool {
        id == source.id
    }
    
    public var elements: [Cell] {
        messages
    }
    
    public var differenceIdentifier: Int {
        id
    }
}
