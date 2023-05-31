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
    
    func downloadImage(for id: String, completion: @escaping (UIImage?) -> Void) async{
        let url = await getURL(for: id)
        if let url {
            downloadImage(from: url, completion: completion)
        }
    }
    
    func getURL(for id: String) async -> String? {
        let ref = Database.database().reference().child("user").child(id).child("profileImageURL")
        var imageURL: String? = nil
        do {
            let snapshot = try await ref.getData()
            if let url = snapshot.value as? String {
                imageURL = url
            }
        } catch {
            print("@ImageStorage: There was an error retrieving image url")
        }
        return imageURL
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let downloadURL = URL(string: url) {
            let task = URLSession.shared.dataTask(with: downloadURL) { (data, response, error) in
                if let error = error {
                    print("Failed to download image: \(error.localizedDescription)")
                    return
                }
                
                if let imageData = data, let image = UIImage(data: imageData) {
                    // Use the downloaded image
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
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
