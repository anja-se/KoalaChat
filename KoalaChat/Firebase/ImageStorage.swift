//
//  ImageStorage.swift
//  KoalaChat
//
//  Created by Anja Seidel on 31.05.23.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

struct ImageStorage {
    let userRef = Database.database().reference().child("user")
    
    func setContactImage(for user: Contact, completion: @escaping () -> Void = {}) {
        Task {
            if let urlString = user.imageURL, let url =
                URL(string: urlString) {
                do {
                    let data = try await URLSession.shared.data(from: url)
                    let image = UIImage(data: data.0)
                    user.image = image
                    print("setting image for \(user.name)")
                    completion()
                    
                } catch {
                    print("There was an error retrieving image data from url: \(error)")
                }
            }
        }
        
    }
    
    func setUserImage(for user: User) {
        Task {
            guard let url = await getURL(for: user.id) else {return}
            do {
                let data = try await URLSession.shared.data(from: url)
                let image = UIImage(data: data.0)
                user.image = image
                print("setting image for \(user.name)")
                
            } catch {
                print("There was an error retrieving image data from url: \(error)")
            }
        }
    }

    func getURL(for id: String) async -> URL? {
        let ref = userRef.child(id).child("profileImageURL")
        var imageURL: URL? = nil
        do {
            let snapshot = try await ref.getData()
            if let urlString = snapshot.value as? String {
                imageURL = URL(string: urlString)
            }
        } catch {
            print("@ImageStorage: There was an error retrieving image url")
        }
        return imageURL
    }
    
    func uloadImage(_ image: UIImage){
        guard let user = AppDelegate.user else {return}
        let filename = "\(user.id).jpg"
        let storageRef = Storage.storage().reference().child("profilePictures/\(filename)")
        let userRef = userRef.child(user.id)
        user.image = image

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("image data failes")
            return
        }

       storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                        print("Error retrieving download URL: \(error)")
                        return
                    }
                    guard let downloadURL = url?.absoluteString else {
                        print("receiving url failed")
                        return
                    }
                user.imageURL = downloadURL
                userRef.child("profileImageURL").setValue(downloadURL)
            }
        }
    }
}
