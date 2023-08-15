//
//  ChatViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 06.03.23.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var textView: UIView!
    
    var chat: Chat?
    let user = AppDelegate.user
    var messages: [Message] {
        if let chat {
            return chat.messages.sorted { $0.timestamp < $1.timestamp }
        } else {
            return []
        }
    }
    var bottomConstraint: NSLayoutConstraint?
    
    
    //MARK: - LifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: MessageCell.identifier, bundle: nil), forCellReuseIdentifier: MessageCell.identifier)
        chat!.delegate = self
        AppDelegate.user?.chatRepo?.chatDelegate = self
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if messages.count > 0 {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    //MARK: - Class methods
    func configure(){
        title = chat!.contact.name
        
        //Layout
        bottomConstraint = textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bottomConstraint?.isActive = true
        
        //Textfield
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.sizeToFit()
        
        //Keyboard Management
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @IBAction func sendButtonClicked(_ sender: UIButton) {
        submit()
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

//MARK: - TableView methods
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let isSender = messages[indexPath.row].senderId == user?.id
        cell.configure(text: messages[indexPath.row].content, sender: isSender)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

//MARK: - ChatDelegate methods
extension ChatViewController: ChatDelegate {
    func update() {
        let row = messages.count - 1
        if row >= 0 {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: false)
            }
        }
    }
}

//MARK: - Keyboard Management
extension ChatViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.bottomConstraint?.isActive = false
            self.bottomConstraint = self.textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -keyboardSize.height)
            self.bottomConstraint?.isActive = true
        }
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if messages.count > 0 {
            let row = messages.count - 1
            if row >= 0 {
                tableView.scrollToRow(at: IndexPath(row: row, section: 0), at: .bottom, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint?.isActive = false
        bottomConstraint = textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        bottomConstraint?.isActive = true
    }
}
