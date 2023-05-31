//
//  Constants.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import Foundation

struct K {
    static let appName = "🐨KoalaChat"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let chatSegue = "GoToChat"
    static let searchSegue = "GoToSearch"
    
    struct FStore {
        static let userCollection = "user"
        static let userIdField = "userId"
        static let nameField = "name"
        static let contactIdsField = "contactIds"
        
        static let messageCollection = "messages"
        static let membersField = "members"
        static let contentField = "content"
        static let senderIdField = "senderId"
        static let recipientIdField = "recipientId"
        static let timestampField = "timestamp"
    }
}
