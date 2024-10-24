//
//  DefaultChatController.swift
//  ChatApp
//
//  Created by qq on 2024.10.18.
//

import Foundation
import ChatLayout

protocol ChatController { }
protocol ChatControllerDelegate : AnyObject {
    func update(with sections : [Section], requiresIsolatedProcess : Bool)
}

final class DefaultChatController : ChatController {
    weak var delegate : ChatControllerDelegate?
    
    private let dataProvider: RandomDataProvider
    
    private var typingState : TypingState = .idle
    private let dispatch = DispatchQueue(label: "xs.chat.native", qos: .userInteractive)
    
    var messages : [RawMessage] = []
    
    init(dataProvider: RandomDataProvider, userId: Int) {
        self.dataProvider = dataProvider
    }
    
    func loadInitialMessages(completion: @escaping ([Section]) -> Void) {
//        dataProvider.loadInitialMessages { [weak self] messages in
        dataProvider.loadInitialMessages { messages in
            self.appendingConvertingToMessages(messages)
            //            print("messages       :         ", messages)
            //            self.markAllMessagesAsReceived {
            //                //                self.markAllMessagesAsReceived {
            self.propagateLatestMessages { sections in
                completion(sections)
            }
            //                //                }
            //            }
        }
    }
    
    func loadPreviousMessages(completion: @escaping ([Section]) -> Void) {
        dataProvider.loadPreviousMessages(completion: { messages in
            self.appendingConvertingToMessages(messages)
            self.markAllMessagesAsReceived {
                //                self.markAllMessagesAsReceived {
                self.propagateLatestMessages { sections in
                    completion(sections)
                }
                //                }
            }
        })
    }
    
    func markAllMessagesAsReceived(completion: @escaping () -> Void) {
//        guard let lastReceivedUUID else {
//            completion()
//            return
//        }
        dispatch.async { [weak self] in
            guard let self else {
                return
            }
            var finished = false
            messages = messages.map { message in
                guard !finished else {
                    if message._id == "" {
                        finished = true
                    }
                    return message
                }
                var message = message
//                message.status = .received
                if message._id == "" {
                    finished = true
                }
                return message
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
//    func sendMessage(_ data: Message.Data, completion: @escaping ([Section]) -> Void) {
//        messages.append(RawMessage(id: UUID(), date: Date(), data: convert(data), userId: userId))
//        propagateLatestMessages { sections in
//            completion(sections)
//        }
//    }
    
    private func appendingConvertingToMessages(_ rawMessages : [RawMessage]) {
        var messages = messages
        messages.append(contentsOf: rawMessages)
        self.messages = messages.sorted(by: {
            $0.createdAt.timeIntervalSince1970 < $1.createdAt.timeIntervalSince1970
        })
    }
    
    private func propagateLatestMessages(completion : @escaping ([Section]) -> Void) {
        var lastMessageStorage : RawMessage?
        dispatch.async {
//            guard let messages = self?.messages else { return }
//            guard let self else {
//                print("working")
//                return
//            }
            let messagesSplitByDay = self.messages
                .map {
                    RawMessage(_id: $0._id, id: "", conversation: $0.conversation, sender: $0.sender, text: $0.text, type: $0.type, updatedAt: $0.updatedAt, objectType: $0.objectType, seenUsers: $0.seenUsers, deletedUsers: $0.deletedUsers, createdAt: $0.createdAt, gif: $0.gif, post: $0.post, reactions: $0.reactions, images: $0.images, video: $0.video, callRequest: $0.callRequest)
                }
                .reduce(into: [[RawMessage]]()) { result, message in
                    guard var section = result.last,
                          let prevMessage = section.last else {
                        let section = [message]
                        result.append(section)
                        return
                    }
                    if Calendar.current.isDate(prevMessage.createdAt, equalTo: message.createdAt, toGranularity: .hour) {
                        section.append(message)
                        result[result.count - 1] = section
                    } else {
                        let section = [message]
                        result.append(section)
                    }
                }
//            print("middle : ", messagesSplitByDay)
            
            let cells = messagesSplitByDay.enumerated().map { index, messages -> [Cell] in
                var cells : [Cell] = Array(messages.enumerated().map { index, message -> [Cell] in
                    let bubble : Cell.BubbleType
                    if index < messages.count - 1 {
                        let nextMessages = messages[index + 1]
                        bubble = nextMessages.sender._id != message.sender._id ? .tailed : .normal
                    }
                    else {
                        bubble = .tailed
                    }
//                    guard message !== messages[index + 1].sender else {
//                        lastMessageStorage = message
//                        return [.message(message, bubbleType: bubble)]
//                    }
                    if index + 1 < messages.count && message.sender._id != messages[index + 1].sender._id {
                        lastMessageStorage = message
                        return [.message(message, bubbleType: bubble)]
                    }
                    
                    let titleCell = Cell.messageGroup(MessageGroup(_id: message._id, title: message.sender.nickname ?? "owner", type: .incoming))
                    
                    if let lastMessage = lastMessageStorage {
                        if lastMessage.sender._id != message.sender._id {
                            lastMessageStorage = message
                            return [titleCell, .message(message, bubbleType: bubble)]
                        } else {
                            lastMessageStorage = message
                            return [.message(message, bubbleType: bubble)]
                        }
                    } else {
                        lastMessageStorage = message
                        return [titleCell, .message(message, bubbleType: bubble)]
                    }
                }.joined())
                
                if let firstMessage = messages.first {
                    let dateCell = Cell.date(DateGroup(_id: firstMessage._id, date: firstMessage.createdAt))
                    cells.insert(dateCell, at: 0)
                }
                
                if self.typingState == .typing,
                   index == messagesSplitByDay.count - 1 {
                    cells.append(.typingIndicator)
                }
                
                return cells
            }.joined()
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else {
                    return
                }
                completion([Section(id: 0, date: Date(), messages: Array(cells))])
            }
        }
    }
}

extension DefaultChatController: ReloadDelegate {
    func reloadMessage(with messageID: String) {
//        repopulateMessages()
    }
}


extension DefaultChatController: EditingAccessoryControllerDelegate {
    func deleteMessage(with _id: String) {
        messages = Array(messages.filter { $0._id != _id })
    }
}
