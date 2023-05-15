//
//  Message.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import Foundation

struct Message: Identifiable, Codable {
    var title: String
    var content: String
    var sender: User
    var recipient: User
    var timestamp = Date()
    var id = UUID()
}
