//
//  Task.swift
//  Todoo
//
//  Created by Shubham Anand on 18/07/18.
//  Copyright © 2018 Shubham Anand. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
    
}
