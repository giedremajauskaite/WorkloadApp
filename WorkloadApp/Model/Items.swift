//
//  Items.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/4/20.
//

import Foundation
import RealmSwift

class Items: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
