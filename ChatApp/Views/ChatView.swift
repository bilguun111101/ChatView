//
//  ChatView.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import UIKit
import ChatLayout
import DifferenceKit

let enableSelfSizingSupport = false
let enableReconfigure = false

final class ChatView : UIView {
    private enum ReactionTypes {
        case deleyadUpdate
    }
    private enum InterfaceActions {
        case changingKeyboardFrame
        case changingContentInsets
        case changingFrameSize
        case sendingMessage
        case scrollingToTop
        case scrollingToBottom
        case showingPreview
        case showingAccessory
        case updatedCollectionInIsolation
    }
    
    private enum ControllerActions {
        case loadingInitialMessages
        case loadingPreviosMessages
        case updatingCollection
    }
    
    private var currentInterfaceActions : SetActor<Set<InterfaceActions>, ReactionTypes> = SetActor()
    private var currentControllerActions : SetActor<Set<ControllerActions>, ReactionTypes> = SetActor()
    
    private var collectionView : UICollectionView!
    public var editNotifier : EditNotifier?
    public var swipeNotifier : SwipeNotifier?
//    public var chatController : ChatController?
    public var chatController : DefaultChatController? {
        didSet {
            chatController?.loadInitialMessages { sections in
                self.currentControllerActions.options.remove(.loadingInitialMessages)
                self.processUpdates(with: sections, animated: true, requiresIsolatedProcess: false)
            }
        }
    }
    public var dataSource : DefaultChatCollectionDataSource? {
        didSet {
            guard let dataSource else { return }
            dataSource.prepare(with: collectionView)
            collectionView.dataSource = dataSource
            collectionView.reloadData()
        }
    }
    private var layout = CollectionViewChatLayout()
    
    private var translationX : CGFloat = 0
    private var currentOffset : CGFloat = 0
    
    private lazy var pangesture : UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleRevealPan(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout.settings.interItemSpacing = 8
        layout.settings.interSectionSpacing = 8
        layout.settings.additionalInsets = .init(top: 8, left: 5, bottom: 8, right: 5)
        layout.keepContentOffsetAtBottomOnBatchUpdates = true
        layout.processOnlyVisibleItemsOnAnimatedBatchUpdates = false
        layout.keepContentAtBottomOfVisibleArea = true
        
        collectionView = .init(frame: bounds, collectionViewLayout: layout)
            .withoutAutoresizingMaskIntoConstraints
        addSubview(collectionView)
        
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.isPrefetchingEnabled = false
        
        collectionView.contentInsetAdjustmentBehavior = .always
        if #available(iOS 13.0, *) {
            collectionView.automaticallyAdjustsScrollIndicatorInsets = true
        }
        
        if #available(iOS 16.0, *), enableSelfSizingSupport {
            collectionView.selfSizingInvalidation = .enabled
            layout.supportSelfSizingInvalidation = true
        }
        
        dataSource?.prepare(with: collectionView)
        
        pangesture.delegate = self

        currentControllerActions.options.insert(.loadingInitialMessages)
        
        let constraints : [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 3.3)
        ]
        NSLayoutConstraint.activate(constraints)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.addGestureRecognizer(pangesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ChatView : UIGestureRecognizerDelegate {
    @objc
    private func handleRevealPan(_ gesture: UIPanGestureRecognizer) {
        guard let collectionView = gesture.view as? UICollectionView,
              let editNotifier,
              !editNotifier.isEditing else {
            currentInterfaceActions.options.remove(.showingAccessory)
            return
        }

        switch gesture.state {
        case .began:
            currentInterfaceActions.options.insert(.showingAccessory)
        case .changed:
            translationX = gesture.translation(in: gesture.view).x
            currentOffset += translationX

            gesture.setTranslation(.zero, in: gesture.view)
            updateTransforms(in: collectionView)
        default:
            UIView.animate(withDuration: 0.25, animations: { () in
                self.translationX = 0
                self.currentOffset = 0
                self.updateTransforms(in: collectionView, transform: .identity)
            }, completion: { _ in
                self.currentInterfaceActions.options.remove(.showingAccessory)
            })
        }
    }
    
    private func updateTransforms(in collectionView: UICollectionView, transform: CGAffineTransform? = nil) {
        collectionView.indexPathsForVisibleItems.forEach {
            guard let cell = collectionView.cellForItem(at: $0) else {
                return
            }
            updateTransform(transform: transform, cell: cell, indexPath: $0)
        }
    }

    private func updateTransform(transform: CGAffineTransform?, cell: UICollectionViewCell, indexPath: IndexPath) {
        var x = currentOffset

        let maxOffset: CGFloat = -100
        x = max(x, maxOffset)
        x = min(x, 0)

        swipeNotifier?.setSwipeCompletionRate(x / maxOffset)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.view is UICollectionView {
            return false
        }
        return [gestureRecognizer, otherGestureRecognizer].contains(pangesture)
    }

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        super.gestureRecognizerShouldBegin(gestureRecognizer)
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == pangesture {
            let translation = gesture.translation(in: gesture.view)
            return (abs(translation.x) > abs(translation.y)) && (gesture == pangesture)
        }

        return true
    }
}

extension ChatView : ChatControllerDelegate {
    func update(with sections: [Section], requiresIsolatedProcess: Bool) {
        let requiresIsolatedProcess = layout.keepContentAtBottomOfVisibleArea == true && layout.collectionViewContentSize.height < layout.visibleBounds.height ? true : requiresIsolatedProcess
        processUpdates(with: sections, animated: true, requiresIsolatedProcess: requiresIsolatedProcess)
    }
    
    private func processUpdates(with sections: [Section], animated: Bool = true, requiresIsolatedProcess: Bool, completion: (() -> Void)? = nil) {
        //        guard isViewLoaded else {
        //            dataSource?.sections = sections
        //            return
        //        }
        guard currentInterfaceActions.options.isEmpty else {
            let reaction = SetActor<Set<InterfaceActions>, ReactionTypes>.Reaction(type: .deleyadUpdate,
                                                                                   action: .onEmpty,
                                                                                   executionType: .once,
                                                                                   actionBlock: { [weak self] in
                guard let self else {
                    return
                }
                processUpdates(with: sections, animated: animated, requiresIsolatedProcess: requiresIsolatedProcess, completion: completion)
            })
            currentInterfaceActions.add(reaction: reaction)
            return
        }
        
        func process() {
            let changeSet = StagedChangeset(source: dataSource?.sections ?? [], target: sections).flattenIfPossible()
            
            guard !changeSet.isEmpty else {
                completion?()
                return
            }
            
            if requiresIsolatedProcess {
                layout.processOnlyVisibleItemsOnAnimatedBatchUpdates = true
                currentInterfaceActions.options.insert(.updatedCollectionInIsolation)
            }
            currentControllerActions.options.insert(.updatingCollection)
            collectionView.reload(using: changeSet,
                                  interrupt: { changeSet in
                guard changeSet.sectionInserted.isEmpty else {
                    return true
                }
                return false
            },
                                  onInterruptedReload: {
                let positionSnapshot = ChatLayoutPositionSnapshot(indexPath: IndexPath(item: 0, section: sections.count - 1), kind: .footer, edge: .bottom)
                self.collectionView.reloadData()
                // We want so that user on reload appeared at the very bottom of the layout
                self.layout.restoreContentOffset(with: positionSnapshot)
            },
                                  completion: { _ in
                DispatchQueue.main.async {
                    self.layout.processOnlyVisibleItemsOnAnimatedBatchUpdates = false
                    if requiresIsolatedProcess {
                        self.currentInterfaceActions.options.remove(.updatedCollectionInIsolation)
                    }
                    completion?()
                    self.currentControllerActions.options.remove(.updatingCollection)
                }
            },
                                  setData: { data in
                self.dataSource?.sections = data
            })
        }
        
        if animated {
            process()
        } else {
            UIView.performWithoutAnimation {
                process()
            }
        }
    }
}


extension ChatView : UICollectionViewDelegate {
    @available(iOS 13.0, *)
    private func preview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String,
              let dataSource
        else {
            return nil
        }
        let components = identifier.split(separator: "|")
        guard components.count == 2,
              let sectionIndex = Int(components[0]),
              let itemIndex = Int(components[1]),
              let cell = collectionView.cellForItem(at: IndexPath(item: itemIndex, section: sectionIndex)) as? TextMessageCollectionCell else {
            return nil
        }

        let item = dataSource.sections[0].messages[itemIndex]
        switch item {
        case let .message(message, bubbleType: _):
            switch message.objectType {
            case .text:
                let parameters = UIPreviewParameters()
                parameters.visiblePath = cell.customView.customView.customView.maskingPath
                let center = cell.customView.customView.customView.center

                return UITargetedDragPreview(
                    view: cell.customView.customView.customView,
                    parameters: parameters,
                    target: .init(
                        container: cell.customView.customView,
                        center: center,
                        transform: .init(translationX: 1, y: 0)
                    )
                )
            case .gif:
                let parameters = UIPreviewParameters()
//                parameters.visiblePath = cell.customView.customView.customView.customView.maskingPath
                let center = cell.customView.customView.customView.customView.center

                return UITargetedDragPreview(
                    view: cell.customView.customView.customView.customView,
                    parameters: parameters,
                    target: .init(
                        container: cell.customView.customView.customView.customView,
                        center: center,
                        transform: .init(translationX: 1, y: 0)
                    )
                )
            default:
                return nil
            }
        default:
            return nil
        }
    }

    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        preview(for: configuration)
    }

    @available(iOS 13.0, *)
    public func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        preview(for: configuration)
    }

    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard !currentInterfaceActions.options.contains(.showingPreview),
              !currentControllerActions.options.contains(.updatingCollection),
              let dataSource
        else {
            return nil
        }
        let item = dataSource.sections[indexPath.section].messages[indexPath.item]
        switch item {
        case let .message(message, bubbleType: _):
            switch message.objectType {
            case .text:
                let body = message.text
                let actions = [UIAction(title: "Copy", image: nil, identifier: nil) { [body] _ in
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = body
                }, UIAction(title: "Delete", image: UIImage(named: "trash"), identifier: nil) {
                    [body] _ in
                    print("delete")
                }]
                let menu = UIMenu(title: "", children: actions)
                let identifier: NSString = "\(indexPath.section)|\(indexPath.item)" as NSString
                currentInterfaceActions.options.insert(.showingPreview)
                return UIContextMenuConfiguration(
                    identifier: identifier,
                    previewProvider: nil,
                    actionProvider: { _ in menu })
            case .gif:
                let body = message.text
                let actions = [UIAction(title: "Copy", image: nil, identifier: nil) { [body] _ in
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = body
                }, UIAction(title: "Delete", image: UIImage(named: "trash"), identifier: nil) {
                    [body] _ in
                    print("delete")
                }]
                let menu = UIMenu(title: "", children: actions)
                let identifier: NSString = "\(indexPath.section)|\(indexPath.item)" as NSString
                currentInterfaceActions.options.insert(.showingPreview)
                return UIContextMenuConfiguration(
                    identifier: identifier,
                    previewProvider: nil,
                    actionProvider: { _ in menu })
            default:
                return nil
            }
        default:
            return nil
        }
    }

    @available(iOS 13.2, *)
    func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        animator?.addCompletion {
            self.currentInterfaceActions.options.remove(.showingPreview)
        }
    }
}
