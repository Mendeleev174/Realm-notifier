//
//  Notes.swift
//  Realm notifier
//
//  Created by Александр Щербинин on 05.04.2023.
//

import Foundation
import RealmSwift

class Notes: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var text: String? = nil
}
