//
//  Tasks.swift
//  WorkloadApp
//
//  Created by Giedre Majauskaite on 10/4/20.
//

import Foundation
import RealmSwift

class Tasks: Object {
    @objc dynamic var time: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var alert: Bool = false
}
