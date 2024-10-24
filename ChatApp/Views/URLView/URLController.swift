//
//  URLController.swift
//  ChatApp
//
//  Created by qq on 2024.10.19.
//

import Foundation
import LinkPresentation

final class URLController {
    let url : URL?
    var metadata : LPLinkMetadata?
    weak var delegate : ReloadDelegate?
    weak var view : URLView? {
        didSet {
            UIView.performWithoutAnimation {
                view?.reloadData()
            }
        }
    }
    
    private let provider = LPMetadataProvider()
    private let messageID : String
    private let bubbleContainer : BubbleController
    
    init(url: URL, metadata: LPLinkMetadata?, messageID: String, bubbleContainer: BubbleController) {
        self.url = url
        self.metadata = metadata
        self.messageID = messageID
        self.bubbleContainer = bubbleContainer
        
        if let url = self.url {
            provider.startFetchingMetadata(for: url, completionHandler: { metadata, error in
                if let error = error {
                    print("error  :  ", error.localizedDescription)
                    return
                }
            })
//            provider.startFetchingMetadata(for: url) { metadata, error in
//                guard let metadata,
//                      error == nil else { return }
//                DispatchQueue.main.async { [weak self] in
//                    guard let self else { return }
//                    if enableReconfigure,
//                       #available(iOS 16.0, *) {
//                        self.metadata = metadata
//                        view?.reloadData()
//                    }
//                }
//            }
        }
    }
}
