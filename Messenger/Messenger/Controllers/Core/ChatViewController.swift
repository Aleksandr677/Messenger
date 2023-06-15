//
//  ViewController.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-13.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var messageMV: MessagesViewModel? = nil
    private var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.dataSource = self
        tableView.delegate = self
        messageTextfield.delegate = self
        messageMV = MessagesViewModel(tableView: tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        if let textMessage = messageTextfield.text {
            if textMessage != "" {
                messageMV?.addMessage(tableView: self.tableView, messageString: textMessage)
            }
        }
        self.messageTextfield.text = ""
        messageTextfield.endEditing(true)
    }
    
    @IBAction func refreshButtonPressed(_ sender: UIButton) {
        if messageMV?.allMessages.count == 0 {
            messageMV?.loadMessages(tableView: self.tableView)
        }
        
        if messageMV?.allMessages.count ?? 0 > 0 {
            UIView.animate(withDuration: 0.5) {
                self.refreshButton.isEnabled = false
                self.refreshButton.alpha = 0.0
            }
        }
    }
    
    //Manage the keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.bottomViewConstraint.constant = 8.0
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            self.bottomViewConstraint.constant = 0.0
        }
    }
}

//MARK: - TableView Data Source
extension ChatViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageMV?.allMessages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.cellID, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.label.text = messageMV?.allMessages[indexPath.row]
        cell.personImageView.image = messageMV?.image
        if messageMV?.allMessages.count ?? 0 > 0 {
            UIView.animate(withDuration: 0.0) {
                self.refreshButton.isEnabled = false
                self.refreshButton.alpha = 0.0
            }
        }
        return cell
    }
}

//MARK: - TableView Delegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (messageMV?.allMessages.count ?? 0) - (messageMV?.allMessages.count ?? 0 - 1) {
            messageMV?.page += 1
            messageMV?.loadMessages(tableView: self.tableView)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.indexPath = indexPath
        performSegue(withIdentifier: "detailsViewControllerIdentifier", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - PREPARE CHILD VC
extension ChatViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "detailsViewControllerIdentifier" {
          let detailsVC = segue.destination as! DetailsViewController
           detailsVC.messageImage = messageMV?.image ?? UIImage(systemName: "person.circle")!
           detailsVC.message = messageMV?.allMessages[self.indexPath.row] ?? "Nothing in here"
           detailsVC.messageTime = Date.now
           detailsVC.indexPath = self.indexPath
           detailsVC.messageVM = self.messageMV
           detailsVC.delegate = self
        }
    }
}

//MARK: - Delegate method for deleting
extension ChatViewController: DeleteMessageProtocol {
    func deleteMessage() {
        self.tableView.reloadData()
    }
}


//MARK: - TextField Delegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.endEditing(true)
        tableView.scrollToRow(at: IndexPath(row: (messageMV?.allMessages.count ?? 0) - 1, section: 0), at: .bottom, animated: true)
        return true
    }
}
