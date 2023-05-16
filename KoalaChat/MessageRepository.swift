//
//  PostRepository.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import Foundation
import Firebase

class MessageRepository {
    let userId = AppDelegate.userId
    let messagesReference = Firestore.firestore().collection(K.FStore.messageCollection)
    var messages: [String: [Message]] = [:]
    
    init(){
        loadMessages()
    }
    
    private func loadMessages() {
        guard let userId else { return }
        
        Task {
            let messageDocs = try await messagesReference.whereField(K.FStore.membersField, arrayContains: userId).getDocuments().documents
            for doc in messageDocs {
                let data = doc.data()
                if let content = data[K.FStore.contentField] as? String, let senderId = data[K.FStore.senderIdField] as? String, let recipientId = data[K.FStore.recipientIdField] as? String, let timestamp = data[K.FStore.timestampField] as? Date {
                    let members = data[K.FStore.membersField] as! [String]
                    let contact = members[0] == userId ? members[1] : members[0]
                    let message = Message(content: content, senderId: senderId, recipientId: recipientId, timestamp: timestamp)
                    if messages[contact] == nil {
                        messages[contact] = []
                    }
                    messages[contact]!.append(message)
                }
            }
        }
    }
    
    func getMessages(for contactId: String) -> [Message] {
        return messages[contactId] ?? []
    }
}
