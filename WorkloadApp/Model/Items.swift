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
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
