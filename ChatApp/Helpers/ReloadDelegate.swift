//
//  ReloadDelegate.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation

protocol ReloadDelegate : AnyObject {
    func reloadMessage(with messageID : String)
}
