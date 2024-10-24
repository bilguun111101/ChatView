//
//  ViewController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataProvider = DefaultRandomDataProvider(receiverId: 0, usersIds: [0, 1, 2])
        let messageController = DefaultChatController(dataProvider: dataProvider, userId: 0)

        let editNotifier = EditNotifier()
        let swipeNotifier = SwipeNotifier()
        let dataSource = DefaultChatCollectionDataSource(
            reloadDelegate: messageController,
            editinigDelegate: messageController,
            editNotifier: editNotifier,
            swipeNotifier: swipeNotifier
        )
        
        let messageView = ChatView(frame: .zero)
            .withoutAutoresizingMaskIntoConstraints
        messageView.dataSource = dataSource
        messageView.editNotifier = editNotifier
        messageView.swipeNotifier = swipeNotifier
        messageView.chatController = messageController
        
//        messageController.loadInitialMessages(completion: { sections in
//            print("sections  :: : : : :: : :::  :: : : : : ::       ", sections)
//        })
        
//        dataProvider.delegate = messageController as! any RandomDataProviderDelegate
        
        view.addSubview(messageView)
        let constraints : [NSLayoutConstraint] = [
            messageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            messageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            messageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

