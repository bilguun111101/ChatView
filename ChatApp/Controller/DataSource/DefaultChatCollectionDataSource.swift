//
//  DefaultChatCollectionDataSource.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout
import UIKit

typealias TextMessageCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, TextMessageView, StatusView>>>
typealias TitleCollectionCell = ContainerCollectionViewCell<UILabel>
typealias UserTitleCollectionCell = ContainerCollectionViewCell<SwappingContainerView<EdgeAligningView<UILabel>, UIImageView>>
typealias URLCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, URLView, StatusView>>>
typealias GifCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView,
    MainContainerView<AvatarView, GifMessageView, StatusView>>>
typealias CallCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, CallMessageView, StatusView>>>
typealias GroupInfoCollectionCell = ContainerCollectionViewCell<GroupInfoView>
typealias ImageCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, ImageMessageView, StatusView>>>
typealias VideoCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, VideoMessageView, StatusView>>>
typealias AdCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, AdMessageView, StatusView>>>
typealias PostCollectionCell = ContainerCollectionViewCell<MessageContainerView<EditingAccessoryView, MainContainerView<AvatarView, PostMessageView, StatusView>>>

final class DefaultChatCollectionDataSource : NSObject, ChatCollectionDataSource {
    private unowned var reloadDelegate : ReloadDelegate
    private unowned var editinigDelegate : EditingAccessoryControllerDelegate
    
    private let editNotifier : EditNotifier
    private let swipeNotifier : SwipeNotifier
    
    var sections: [Section] = [] {
        didSet {
            oldSections = oldValue
        }
    }
    private var oldSections : [Section] = []
    
    init(
        reloadDelegate: ReloadDelegate,
        editinigDelegate: EditingAccessoryControllerDelegate,
        editNotifier: EditNotifier,
        swipeNotifier: SwipeNotifier
    ) {
        self.reloadDelegate = reloadDelegate
        self.editinigDelegate = editinigDelegate
        self.editNotifier = editNotifier
        self.swipeNotifier = swipeNotifier
    }
    
    func prepare(with collectionView: UICollectionView) {
        collectionView.register(TextMessageCollectionCell.self, forCellWithReuseIdentifier: TextMessageCollectionCell.reuseIdentifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(TitleCollectionCell.self, forCellWithReuseIdentifier: TitleCollectionCell.reuseIdentifier)
        collectionView.register(UserTitleCollectionCell.self, forCellWithReuseIdentifier: UserTitleCollectionCell.reuseIdentifier)
        collectionView.register(URLCollectionCell.self, forCellWithReuseIdentifier: URLCollectionCell.reuseIdentifier)
        collectionView.register(GifCollectionCell.self, forCellWithReuseIdentifier: GifCollectionCell.reuseIdentifier)
        collectionView.register(CallCollectionCell.self, forCellWithReuseIdentifier: CallCollectionCell.reuseIdentifier)
        collectionView.register(GroupInfoCollectionCell.self, forCellWithReuseIdentifier: GroupInfoCollectionCell.reuseIdentifier)
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: ImageCollectionCell.reuseIdentifier)
        collectionView.register(VideoCollectionCell.self, forCellWithReuseIdentifier: VideoCollectionCell.reuseIdentifier)
        collectionView.register(AdCollectionCell.self, forCellWithReuseIdentifier: AdCollectionCell.reuseIdentifier)
        collectionView.register(PostCollectionCell.self, forCellWithReuseIdentifier: PostCollectionCell.reuseIdentifier)
    }
    
    private func createGroupInfoCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupInfoCollectionCell.reuseIdentifier, for: indexPath) as! GroupInfoCollectionCell
        let controller = GroupInfoController(message: message, type: message.type)
        cell.customView.setup(with: controller)
        controller.view = cell.customView
        
        cell.contentView.layoutMargins = UIEdgeInsets(top: 2, left: 30, bottom: -4, right: 30)
        
        return cell
    }
    
    private func createVideoCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionCell.reuseIdentifier, for: indexPath) as! VideoCollectionCell
        let bubbleView = cell.customView.customView.customView
        setupMessageContainerView(cell.customView, messageId: message._id, alignment: alignment)
        setupMainMessageView(cell.customView.customView, user: user, alignment: messageType, bubble: bubbleType, status: status)
        setupSwipeHandlingAccessory(cell.customView.customView, date: message.createdAt, accessoryConnectingView: cell.customView)

        let controller = VideoMessageController(
            message: message,
            type: .incoming
        )

        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        cell.delegate = bubbleView.customView
        return cell
    }
    
    private func createImageCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.reuseIdentifier, for: indexPath) as! ImageCollectionCell
        
        setupMessageContainerView(cell.customView, messageId: message._id, alignment: alignment)
        setupMainMessageView(cell.customView.customView, user: user, alignment: messageType, bubble: bubbleType, status: status)
        setupSwipeHandlingAccessory(cell.customView.customView, date: message.createdAt, accessoryConnectingView: cell.customView)

        let bubbleView = cell.customView.customView.customView
        let controller = ImageMessageController(
            message: message,
            type: .incoming
        )

        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        cell.delegate = bubbleView.customView
        return cell
    }
    
    private func createCallCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CallCollectionCell.reuseIdentifier,
            for: indexPath) as! CallCollectionCell
        setupMessageContainerView(
            cell.customView,
            messageId: message._id,
            alignment: alignment
        )
        setupMainMessageView(
            cell.customView.customView,
            user: message.sender,
            alignment: messageType,
            bubble: bubbleType,
            status: status
        )
        setupSwipeHandlingAccessory(
            cell.customView.customView,
            date: message.createdAt,
            accessoryConnectingView: cell.customView
        )
        
        let bubbleView = cell.customView.customView.customView
        let controller = CallMessageController(
            message: message,
            type: messageType,
            bubbleController:
                buildTextBubbleController(
                    bubbleView: bubbleView,
                    messageType: messageType,
                    bubble: bubbleType)
        )
        
        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        cell.delegate = bubbleView.customView
        
        return cell
    }
    
    private func createAdCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionCell.reuseIdentifier, for: indexPath) as! AdCollectionCell
        setupMessageContainerView(
            cell.customView,
            messageId: message._id,
            alignment: alignment
        )
        setupMainMessageView(
            cell.customView.customView,
            user: user,
            alignment: messageType,
            bubble: bubbleType,
            status: status
        )
        setupSwipeHandlingAccessory(
            cell.customView.customView,
            date: message.createdAt,
            accessoryConnectingView: cell.customView
        )
        
        let bubbleView = cell.customView.customView.customView
        _ = buildTextBubbleController(
            bubbleView: bubbleView,
            messageType: messageType,
            bubble: bubbleType)
        let controller = AdMessageController(
            message: message,
            type: messageType
        )
        
        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        cell.delegate = bubbleView.customView
        
        return cell
    }
    
    private func createPostCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionCell.reuseIdentifier, for: indexPath) as! PostCollectionCell
        setupMessageContainerView(
            cell.customView,
            messageId: message._id,
            alignment: alignment
        )
        setupMainMessageView(
            cell.customView.customView,
            user: user,
            alignment: messageType,
            bubble: bubbleType,
            status: status
        )
        setupSwipeHandlingAccessory(
            cell.customView.customView,
            date: message.createdAt,
            accessoryConnectingView: cell.customView
        )
        let bubbleView = cell.customView.customView.customView
//        _ = buildTextBubbleController(
//            bubbleView: bubbleView,
//            messageType: messageType,
//            bubble: bubbleType)
//        _ = buildBezierBubbleController(for: bubbleView, messageType: messageType, bubbleType: bubbleType)
        let controller = PostMessageController(message: message, type: messageType)
        bubbleView.customView.setup(with: controller)
//        controller.view = bubbleView.customView
//        cell.delegate = bubbleView.customView
        
        return cell
    }
    
    private func createTextCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextMessageCollectionCell.reuseIdentifier, for: indexPath) as! TextMessageCollectionCell
        setupMessageContainerView(
            cell.customView,
            messageId: message._id,
            alignment: alignment
        )
        setupMainMessageView(
            cell.customView.customView,
            user: user,
            alignment: messageType,
            bubble: bubbleType,
            status: status
        )
        setupSwipeHandlingAccessory(
            cell.customView.customView,
            date: message.createdAt,
            accessoryConnectingView: cell.customView
        )
        
        let bubbleView = cell.customView.customView.customView
        let controller = TextMessageController(
            message: message,
            type: messageType,
            bubbleController:
                buildTextBubbleController(
                    bubbleView: bubbleView,
                    messageType: messageType,
                    bubble: bubbleType)
        )
        
        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        cell.delegate = bubbleView.customView
        
        return cell
    }
    
    private func createDateTitle(collectionView : UICollectionView, indexPath : IndexPath, alignment : ChatItemAlignment, title : String) -> TitleCollectionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionCell.reuseIdentifier, for: indexPath) as! TitleCollectionCell
        cell.customView.preferredMaxLayoutWidth = (collectionView.collectionViewLayout as? CollectionViewChatLayout)?.layoutFrame.width ?? collectionView.frame.width
        cell.customView.textAlignment = .center
        cell.customView.text = title
        cell.customView.textColor = .gray
        cell.customView.numberOfLines = 0
        cell.customView.font = .preferredFont(forTextStyle: .caption2)
        cell.contentView.layoutMargins = .init(top: 2, left: 0, bottom: 2, right: 0)
        return cell
    }
    
    private func createGifCell(
        collectionView : UICollectionView,
        message : RawMessage,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> GifCollectionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCollectionCell.reuseIdentifier, for: indexPath) as! GifCollectionCell
        
        setupMessageContainerView(cell.customView, messageId: message._id, alignment: alignment)
        setupMainMessageView(cell.customView.customView, user: user, alignment: messageType, bubble: bubbleType, status: status)
        setupSwipeHandlingAccessory(cell.customView.customView, date: message.createdAt, accessoryConnectingView: cell.customView)

        let bubbleView = cell.customView.customView.customView
        let controller = GifMessageController(
            message: message,
            type: .incoming
        )

        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        cell.delegate = bubbleView.customView
        return cell
    }
    
    private func createURLCell(
        collectionView : UICollectionView,
        message : RawMessage,
        url : URL,
        indexPath : IndexPath,
        alignment : ChatItemAlignment,
        user : RawUser,
        bubbleType : Cell.BubbleType,
        status : MessageStatus,
        messageType : MessagePosition
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: URLCollectionCell.reuseIdentifier, for: indexPath) as! URLCollectionCell
        setupMessageContainerView(cell.customView, messageId: message._id, alignment: alignment)
        setupMainMessageView(cell.customView.customView, user: user, alignment: messageType, bubble: bubbleType, status: status)

        setupSwipeHandlingAccessory(cell.customView.customView, date: message.createdAt, accessoryConnectingView: cell.customView)

        let bubbleView = cell.customView.customView.customView
        let controller = URLController(url: url, metadata: nil,
                                       messageID: message._id,
                                       bubbleContainer: buildBezierBubbleController(
                                        for: bubbleView,
                                        messageType: messageType,
                                        bubbleType: bubbleType)
        )

        bubbleView.customView.setup(with: controller)
        controller.view = bubbleView.customView
        controller.delegate = reloadDelegate
        cell.delegate = bubbleView.customView

        return cell
    }
    
    private func createGroupTitle(collectionView: UICollectionView, indexPath: IndexPath, alignment: ChatItemAlignment, title: String) -> UserTitleCollectionCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserTitleCollectionCell.reuseIdentifier, for: indexPath) as! UserTitleCollectionCell
        cell.customView.spacing = 2

        cell.customView.customView.customView.text = title
        cell.customView.customView.customView.preferredMaxLayoutWidth = (collectionView.collectionViewLayout as? CollectionViewChatLayout)?.layoutFrame.width ?? collectionView.frame.width
        cell.customView.customView.customView.textColor = .gray
        cell.customView.customView.customView.numberOfLines = 0
        cell.customView.customView.customView.font = .preferredFont(forTextStyle: .caption2)
        cell.customView.customView.flexibleEdges = [.top]

        cell.customView.accessoryView.contentMode = .scaleAspectFit
        cell.customView.accessoryView.tintColor = .gray
        cell.customView.accessoryView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            if cell.customView.accessoryView.image == nil {
                cell.customView.accessoryView.image = UIImage(systemName: "person")
                let constraints = [
                    cell.customView.accessoryView.widthAnchor.constraint(equalTo: cell.customView.accessoryView.heightAnchor),
                    cell.customView.accessoryView.heightAnchor.constraint(equalTo: cell.customView.customView.customView.heightAnchor, constant: 2)
                ]
                constraints.forEach { $0.priority = UILayoutPriority(rawValue: 999) }
                cell.customView.customView.customView.setContentHuggingPriority(.required, for: .vertical)
                cell.customView.accessoryView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
                NSLayoutConstraint.activate(constraints)
            }
        } else {
            cell.customView.accessoryView.isHidden = true
        }
        cell.contentView.layoutMargins = UIEdgeInsets(top: 2, left: 40, bottom: -4, right: 40)
        return cell
    }
    
    private func setupMessageContainerView(
        _ messageContainerView : MessageContainerView<EditingAccessoryView, some Any>,
        messageId : String, alignment : ChatItemAlignment
    ) {
        messageContainerView.alignment = alignment
        if let accessoryView = messageContainerView.accessoryView {
            editNotifier.add(delegate: accessoryView)
            accessoryView.setIsEditing(editNotifier.isEditing)
            
            let controller = EditingAccessoryController(messageID: messageId)
            controller.view = accessoryView
            controller.delegate = editinigDelegate
            accessoryView.setup(with: controller)
        }
    }
    
    private func setMessageContainerView(
        _ messageContainerView : MessageContainerView<EditingAccessoryView, some Any>,
        message : RawMessage,
        alignment : ChatItemAlignment
    ) {
        messageContainerView.alignment = alignment
        if let accessoryView = messageContainerView.accessoryView {
            editNotifier.add(delegate: accessoryView)
            accessoryView.setIsEditing(editNotifier.isEditing)
            
            let controller = EditingAccessoryController(messageID: message._id)
            controller.view = accessoryView
            controller.delegate = editinigDelegate
            accessoryView.setup(with: controller)
        }
    }
    private func setupMainMessageView(
        _ cellView : MainContainerView<AvatarView, some Any, StatusView>,
        user : RawUser,
        alignment : MessagePosition,
        bubble : Cell.BubbleType,
        status : MessageStatus
    ) {
        cellView.containerView.alignment = .bottom
        cellView.containerView.leadingView?.isHiddenSafe = !alignment.isIncoming
        cellView.containerView.leadingView?.alpha = alignment.isIncoming ? 1.0 : 0.0
        cellView.containerView.trailingView?.isHiddenSafe = alignment.isIncoming
        cellView.containerView.trailingView?.alpha = alignment.isIncoming ? 0.0 : 1.0
        cellView.containerView.trailingView?.setup(with: status)
        if bubble == .normal {
            cellView.containerView.leadingView?.alpha = 0.0
        }
        if let avatarView = cellView.containerView.leadingView {
            let avatarViewController = AvatarViewController(user: user, bubble: bubble)
            avatarView.setup(with: avatarViewController)
            avatarViewController.view = avatarView
            if let avatarDelegate = cellView.customView.customView as? AvatarViewDelegate {
                avatarView.delegate = avatarDelegate
            } else {
                avatarView.delegate = nil
            }
        }
    }
    
    private func setupSwipeHandlingAccessory(
        _ cellView : MainContainerView<AvatarView, some Any, StatusView>,
        date : Date,
        accessoryConnectingView : UIView
    ) {
        cellView.accessoryConnectingView = accessoryConnectingView
        cellView.accessoryView.setup(with: .init(date: date))
        cellView.accessorySafeAreaInsets = swipeNotifier.accessorySafeAreaInsets
        cellView.swipeCompletionRate = swipeNotifier.swipeCompletionRate
        swipeNotifier.add(delegate: cellView)
    }
    
    private func buildTextBubbleController(bubbleView : BezierMaskedView<some Any>, messageType : MessagePosition, bubble : Cell.BubbleType) -> BubbleController {
        let textBubbleController = TextBubbleController(type: messageType, bubbleType: bubble, bubbleView: bubbleView)
        let bubbleController = BezierBubbleController(
            controllerProxy: textBubbleController,
            type: messageType,
            bubbleType: bubble,
            bubbleView: bubbleView
        )
        return bubbleController
    }
    
    private func buildBezierBubbleController(for bubbleView : BezierMaskedView<some Any>, messageType : MessagePosition, bubbleType : Cell.BubbleType) -> BubbleController {
        let contentBubbleController = FullCellContentBubbleController(bubbleView: bubbleView)
        bubbleView.bubbleType = bubbleType
        let bubbleController = BezierBubbleController(controllerProxy: contentBubbleController, type: messageType, bubbleType: bubbleType, bubbleView: bubbleView)
        return bubbleController
    }
}


extension DefaultChatCollectionDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sections[indexPath.section].messages[indexPath.item]
        switch cell {
        case let .message(message, bubbleType: bubbleType):
            switch message.type {
            case .chat:
                switch message.objectType {
                case .text:
                    let cell = createTextCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
    //                    alignment: .trailing,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .call:
                    let cell = createCallCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .image:
                    let cell = createImageCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .video:
                    let cell = createVideoCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .gif:
                    let cell = createGifCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .ad:
                    let cell = createAdCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .post:
//                    let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                    let cell = createPostCell(
                        collectionView: collectionView,
                        message: message,
                        indexPath: indexPath,
                        alignment: cell.alignment,
                        user: message.sender,
                        bubbleType: bubbleType,
                        status: .read,
                        messageType: .incoming
                    )
                    return cell
                case .place:
                    let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                    return cells
                }
            case .typing:
                let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                return cells
            case .call:
                let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
                return cells
            default :
                let cell = createGroupInfoCell(
                    collectionView: collectionView,
                    message: message,
                    indexPath: indexPath
                )
                return cell
//                let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
//                return cells
            }
        case .typingIndicator:
            let cells = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            return cells
        case let .messageGroup(group):
            let cell = createGroupTitle(
                collectionView: collectionView,
                indexPath: indexPath,
                alignment: cell.alignment,
                title: group.title
            )
            return cell
        case let .date(group):
            let cell = createDateTitle(
                collectionView: collectionView,
                indexPath: indexPath,
                alignment: .trailing,
                title: group.value
            )
            return cell
        }
    }
}
