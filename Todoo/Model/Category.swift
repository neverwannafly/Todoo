//
//  Category.swift
//  Todoo
//
//  Created by Shubham Anand on 18/07/18.
//  Copyright © 2018 Shubham Anand. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var color: String = "1D9BF6"
    
    let tasks = List<Task>()
}
