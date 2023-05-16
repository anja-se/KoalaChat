//
//  ContactManager.swift
//  KoalaChat
//
//  Created by Anja Seidel on 16.05.23.
//

import Foundation
import Firebase

class ContactManager {
    let userId = AppDelegate.userId
    let usersReference = Firestore.firestore().collection(K.FStore.userCollection)
    var contacts: [Contact] = []
    
    init(){
        loadData()
    }
    
    private func loadData() {
        guard let userId else { return }
        Task {
            var contactIds = [""]
            let userDocs = try await usersReference.whereField(K.FStore.userIdField, isEqualTo: userId).getDocuments().documents
            for doc in userDocs {
                let data = doc.data()
                if let ids = data[K.FStore.contactIdsField] as? [String] {
                    contactIds = ids
                }
            }
            let contactDocs = try await usersReference.whereField(K.FStore.userIdField, in: contactIds).getDocuments().documents
            for doc in contactDocs {
                let data = doc.data()
                if let id = data[K.FStore.userIdField] as? String, let name = data[K.FStore.nameField] as? String {
                    contacts.append(Contact(id: id, name: name))
                }
            }
        }
    }
    
    func getContacts() -> [Contact] {
        return contacts
    }
    
}
