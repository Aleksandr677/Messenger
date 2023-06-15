//
//  DetailsViewController.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-14.
//

import UIKit

protocol DeleteMessageProtocol {
    func deleteMessage()
}

class DetailsViewController: UIViewController {
    @IBOutlet weak var imageTimeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    
    var messageImage: UIImage = UIImage()
    var message: String = ""
    var messageTime: Date = Date()
    var messageVM: MessagesViewModel?
    var indexPath: IndexPath = IndexPath()
    var delegate: DeleteMessageProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor(named: "BrandLightPurple")
        style()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageTimeLabel.alpha = 0.0
        messageLabel.alpha = 0.0
        messageImageView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.imageTimeLabel.alpha = 1.0
            self?.messageLabel.alpha = 1.0
            self?.messageImageView.alpha = 1.0
        }
    }
    
    private func style() {
        imageTimeLabel.text = String("Date: \(messageTime.formatted(date: .numeric, time: .standard))")
        messageLabel.text = "Message: \(message)"
        messageImageView.image = messageImage
    }
    
    @IBAction func deleteMessage(_ sender: Any) {
        messageVM?.removeMessage(indexPath: indexPath)
        delegate?.deleteMessage()
    }
}
