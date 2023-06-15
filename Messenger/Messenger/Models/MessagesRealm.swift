//
//  MessagesRealm.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-14.
//

import UIKit
import RealmSwift

class MessagesRealm: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var messages: List<String>
    @Persisted var messageImage: List<Data>
 
    override class func primaryKey() -> String? {
        "id"
    }
}
