//
//  User.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import Foundation
import Firebase

struct User: Identifiable, Codable {
    let contactsReference = Firestore.firestore().collection("contacts")
    let id: String
    let name: String
    var contactIds: [String] = []
    
    enum CodingKeys: CodingKey {
        case id, name
    }
}
