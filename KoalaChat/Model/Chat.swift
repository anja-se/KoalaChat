//
//  Chat.swift
//  KoalaChat
//
//  Created by Anja Seidel on 26.05.23.
//

import Foundation

class Chat {
    var delegate: ChatDelegate?
    let id: String
    let contact: Contact
    var messages: [Message] {
        didSet {
            delegate?.update()
        }
    }
    
    init(id: String? = nil, contact: Contact, messages: [Message]) {
        if let id {
            self.id = id
        } else {
            self.id = UUID().uuidString
        }
        self.contact = contact
        self.messages = messages
    }
}

extension Chat: Comparable {
    static func < (lhs: Chat, rhs: Chat) -> Bool {
        lhs.contact.name < rhs.contact.name
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
    }
}

protocol ChatDelegate {
    func update()
}
