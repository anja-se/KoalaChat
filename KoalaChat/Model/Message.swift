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
    var recipientId: String
    var timestamp = Date()
}
