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
    
    private let auth = Auth.auth()
    private var listener: AuthStateDidChangeListenerHandle?
    
    init() {
        listener = auth.addStateDidChangeListener({ [weak self] _, user in
            self?.user = user.map(User.init(from:))
            AppDelegate.user = self?.user
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
    }
    
    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Sign-in error: \(error.localizedDescription)")
            } else if let _ = authResult {
                completion()
            }
        }
    }
    
    func signOut() throws {
        try auth.signOut()
        AppDelegate.user = nil
    }
}

private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
