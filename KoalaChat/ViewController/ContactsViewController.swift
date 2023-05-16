//
//  ContactsViewController.swift
//  KoalaChat
//
//  Created by Anja Seidel on 11.05.23.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var contacts: [Contact] = []
    var contactIndex = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: ContactCell.identifier, bundle: nil), forCellReuseIdentifier: ContactCell.identifier)
        contacts = AppDelegate.authService.user?.contacts ?? []
    }
    
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try AppDelegate.authService.signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactCell.identifier, for: indexPath) as! ContactCell
        cell.configure(name: contacts[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactIndex = indexPath.row
        self.performSegue(withIdentifier: K.chatSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.chatSegue {
            let vc = segue.destination as! ChatViewController
            vc.contact = contacts[contactIndex]
            //guard let messages =  else {return}
            vc.messages = AppDelegate.authService.user?.repo.getMessages(for: contacts[contactIndex].id) ?? []
        }
    }
    

}
