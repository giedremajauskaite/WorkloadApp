//
//  Category.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/4/20.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    let items = List<Items>()
}
