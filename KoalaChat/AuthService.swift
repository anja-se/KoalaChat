//
//  AuthService.swift
//  KoalaChat
//
//  Created by Anja Seidel on 09.05.23.
//

import Foundation
import FirebaseAuth
import Firebase

class AuthService {
    
    var user: User?
    private let auth = Auth.auth()
    let allUsers = Firestore.firestore().collection("user")
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
        allUsers.addDocument(data: ["id" : id, "name" : name])
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
