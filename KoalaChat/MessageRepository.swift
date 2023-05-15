//
//  PostRepository.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import Foundation
import Firebase

struct MessageRepository {
    let messagesReference = Firestore.firestore().collection("messages")
    var messages: [String: [String]]
}
