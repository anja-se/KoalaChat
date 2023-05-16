//
//  User.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import Foundation
import Firebase

struct User: Identifiable, Codable {
    let id: String
    let name: String
    var contacts: [Contact] = []
    let repo = MessageRepository()
    let contactManager = ContactManager()
    
    enum CodingKeys: CodingKey {
        case id, name
    }
    
    init(from firebaseUser: FirebaseAuth.User) {
        self.id = firebaseUser.uid
        self.name = firebaseUser.displayName ?? "Error: No name"
        self.contacts = contactManager.getContacts()
    }
}
