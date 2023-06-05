//
//  User.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import Foundation
import Firebase
import UIKit

class User: Identifiable, Codable {
    let id: String
    let name: String
    var imageURL: String?
    var image: UIImage?
    var chatRepo: ChatRepository?
    var imageStorage = ImageStorage()
    
    enum CodingKeys: CodingKey {
        case id, name, imageURL
    }
    
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? "Error: No name"
        self.chatRepo = ChatRepository(user: self)
        imageStorage.setUserImage(for: self)
    }
    
    func addContact(_ user: Contact) {
        chatRepo!.addContact(user)
    }
}
