//
//  Contact.swift
//  KoalaChat
//
//  Created by Anja Seidel on 15.05.23.
//

import Foundation

struct Contact: Codable {
    let id: String
    var name: String
    var imageURL: String?
}

protocol ContactDelegate {
    func update()
}
