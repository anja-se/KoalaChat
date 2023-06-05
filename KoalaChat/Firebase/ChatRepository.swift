//
//  DatabaseService.swift
//  KoalaChat
//
//  Created by Anja Seidel on 26.05.23.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import UIKit

class ChatRepository {
    let user: User
    var chats: [Chat] = []
    let chatRef = Database.database().reference().child("chats")
    let userRef = Database.database().reference().child("user")
    var contactDelegate: ContactDelegate?
    var chatDelegate: ChatDelegate?
    let imageStorage = ImageStorage()

    init(user: User) {
        self.user = user
        loadData()
    }
    
    func loadData(){
        Task{
            //load chats from user
            userRef.child(user.id).child("chatIDs").observe(.childAdded) { (snapshot: DataSnapshot) in
                guard let id = snapshot.value as? String else {return}
                let allChats = self.chats.map{ $0.id }
                if allChats.contains(id) {return}
                self.makeChat(with: id)
            }
        }
    }
    
    func makeChat(with chatID: String){
        Task {
            do {
                let chatSnapshot = try await self.chatRef.child(chatID).getData()
                guard let chat = chatSnapshot.value as? [String: Any] else {return}
                
                //get contact
                guard let members = chat["members"] as? [String]
                else {
                    print("could not load members")
                    return
                }
                let contactID = members.first { $0 != self.user.id }
                if let contactID {
                    let contact = await self.getContact(with: contactID)
                    guard let contact else {
                        print("could not load contact")
                        return
                    }
                    //create chat
                    let chat = Chat(id: chatID, contact: contact, messages: [])
                    self.chats.append(chat)
                    contactDelegate?.update()
                }
                
                //get messages
                self.addMessageListener(for: chatID)
            } catch {
                print("@ChatRepository: There was an error loading chat data: \(error)")
            }
        }
    }
    
    func addMessageListener(for chatId: String){
        let ref = chatRef.child(chatId)
        ref.child("messages").observe(.childAdded) { (snapshot: DataSnapshot) in
            if let message = snapshot.value as? [String: Any],
               let sender = message["sender"] as? String,
               let timestamp = message["timestamp"] as? TimeInterval,
               let content = message["content"] as? String {
                let i = self.chats.firstIndex { $0.id == chatId }
                guard let i else {return}
                let date = Date(timeIntervalSince1970: timestamp)
                let newMessage = Message(content: content, senderId: sender, timestamp: date)
                self.chats[i].messages.append(newMessage)
                self.chatDelegate?.update()
            }
        }
    }
    
    func getContact(with id: String) async -> Contact? {
        var newContact: Contact?
        do {
            let snapshot = try await userRef.child(id).getData()
            if let contact = snapshot.value as? [String: Any],
               let id = contact["id"] as? String,
               let name = contact["name"] as? String {
                    newContact = Contact(id: id, name: name)
                if let url = contact["profileImageURL"] as? String {
                    newContact!.imageURL = url
                    imageStorage.setContactImage(for: newContact!) {
                        self.contactDelegate?.update()
                    }
                }
            } else {
                print("There was an error retrieving contact with id \(id)")
            }
        } catch {
            print("There was an error creating snapshot: \(error)")
        }
        return newContact
    }
    
    func addContact(_ user: Contact){
        imageStorage.setContactImage(for: user)
        let newChat = Chat(contact: user, messages: [])
        self.chats.append(newChat)
        contactDelegate?.update()
    }
    
    func getAllUser() async throws -> [Contact] {
        var allUser: [Contact] = []
        let snapshot = try await userRef.getData()
        
        if let userArray = snapshot.value as? [String: Any] {
            for (id, userData) in userArray {
                if let user = userData as? [String: Any],
                   let name = user["name"] as? String {
                    var contact = Contact(id: id, name: name)
                    if let url = user["profileImageURL"] as? String {
                        contact.imageURL = url
                    }
                    allUser.append(contact)
                } else {
                    print("could not load userData or name")
                }
            }
        } else {
            print("There was an issue loading user: \(snapshot.key)")
        }
        
        //filter out current user and existing contacts
        let contactIDs = chats.map { $0.contact.id }
        allUser = allUser.filter({ $0.id != self.user.id && !contactIDs.contains($0.id)
        })
        return allUser
    }
    
    func submit(_ content: String, chat: Chat, shouldCreate: Bool = false){
        //let message = Message(content: content, senderId: user.id)
        let ref = chatRef.child(chat.id)
        if shouldCreate {
            ref.setValue([
                "members": [user.id, chat.contact.id]
            ])
            addMessageListener(for: chat.id)
            userRef.child(user.id).child("chatIDs").childByAutoId().setValue(chat.id)
            userRef.child(chat.contact.id).child("chatIDs").childByAutoId().setValue(chat.id)
        }
        ref.child("messages").childByAutoId().setValue([
            "sender": user.id,
            "content": content,
            "timestamp": ServerValue.timestamp()
        ])
    }
}
