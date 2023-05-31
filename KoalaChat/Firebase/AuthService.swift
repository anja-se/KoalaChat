//
//  AuthService.swift
//  KoalaChat
//
//  Created by Anja Seidel on 09.05.23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    
    var user: User?
    let userRef = Database.database().reference().child("user")
    //let allUsers = Firestore.firestore().collection(K.FStore.userCollection)
    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
    init() {
        listener = auth.addStateDidChangeListener({ [weak self] _, user in
            self?.user = user.map(User.init(from:))
        })
        
    }
    
    func createAccount(name: String, email: String, password: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)
        try await result.user.updateProfile(\.displayName, to: name)
        let id = result.user.uid
        //let contacts: [String] = []
        try await userRef.child(id).setValue([
            "id": id,
            "name": name
        ])
//        try await allUsers.document(id).setData([K.FStore.userIdField : id, K.FStore.nameField : name, K.FStore.contactIdsField: contacts])
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            try await auth.signIn(withEmail: email, password: password)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func setContacts(){
        
    }
}

private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
