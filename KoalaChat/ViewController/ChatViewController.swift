//
//  ChatViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    var chat: Chat?
    let user = AppDelegate.user
    var messages: [Message] {
        if let chat {
            return chat.messages.sorted { $0.timestamp < $1.timestamp }
        } else {
            return []
        }
        
    }
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MessageCell.identifier, bundle: nil), forCellReuseIdentifier: MessageCell.identifier)
        chat!.delegate = self
        AppDelegate.user?.chatRepo?.chatDelegate = self
        title = chat!.contact.name
    }
    
    override func viewWillAppear(_ animated: Bool){
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let isSender = messages[indexPath.row].senderId == user?.id
        cell.configure(text: messages[indexPath.row].content, sender: isSender)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        submit()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
    
    func submit() {
        let createChat = chat!.messages.isEmpty
        if let text = textField.text {
            if !text.isEmpty {
                AppDelegate.user!.chatRepo?.submit(text, chat: chat!, shouldCreate: createChat)
            }
            textField.text = ""
        }
    }
}

extension ChatViewController: ChatDelegate {
    func update() {
        let row = messages.count - 1
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: false)
        }
    }
}
