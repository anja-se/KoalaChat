//
//  Message.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import Foundation

struct Message: Codable {
    var content: String
    var senderId: String
    var timestamp: Date
    
    init(content: String, senderId: String, timestamp: Date = Date()) {
        self.content = content
        self.senderId = senderId
        self.timestamp = timestamp
    }
}
