//
//  ChatTableViewCell.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-13.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var personImageView: UIImageView!
    
    static let cellID = "ChatTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = 10
        personImageView.layer.cornerRadius = personImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
