//
//  MessagesViewModel.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-13.
//

import UIKit
import RealmSwift

final class MessagesViewModel {
    var allMessages: [String] = []
    var image = UIImage()
    private let messageManager = MessagesManager()
    private let imageManager = ImagesManager()
    var page: Int = 0
    private var currentRow: Int = 0
    
    let realm = try! Realm()
    let messagesRealm = MessagesRealm()
    
    init(tableView: UITableView) {
        loadImage()
        loadMessages(tableView: tableView)
        print(Realm.Configuration.defaultConfiguration)
    }
    
    func loadMessages(tableView: UITableView) {
        messageManager.fetchMessages(offset: page) { [weak self] results in
            switch results {
            case .success(let messages):
                self?.allMessages.insert(contentsOf: messages.result, at: 0)
                self?.saveMessagesToRealm(messages: messages.result)
                self?.currentRow = messages.result.count
                tableView.reloadData()
                self?.handleScroll(tableView: tableView)
            case .failure(_):
                break
            }
        }
    }
    
    private func loadImage() {
        imageManager.fetchMessages { [weak self] results in
            switch results {
            case .success(let image):
                self?.image = image
            case .failure(_):
                break
            }
        }
    }
    
    private func handleScroll(tableView: UITableView) {
        if page == 0 {
            let indexPath = IndexPath(row: allMessages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
        
        if page > 0 {
            tableView.scrollToRow(at: IndexPath(row: (allMessages.count - allMessages.count) + currentRow, section: 0), at: .middle, animated: false)
        }
    }
    
    func addMessage(tableView: UITableView, messageString: String) {
        allMessages.append(messageString)
        DispatchQueue.main.async { [weak self] in
            tableView.reloadData()
            let indexPath = IndexPath(row: (self?.allMessages.count ?? 0) - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
        try! realm.write({
            messagesRealm.messages.append(messageString)
            if let data = image.pngData() {
                messagesRealm.messageImage.append(data)
            }
        })
    }
    
    func removeMessage(indexPath: IndexPath) {
        allMessages.remove(at: indexPath.row)
    }

    private func saveMessagesToRealm(messages: [String]) {
        try! realm.write({
            if page == 0 {
                realm.add(messagesRealm)
            }
            messagesRealm.messages.append(objectsIn: messages)
            if let data = image.pngData() {
                messagesRealm.messageImage.append(data)
            }
        })
    }
}
