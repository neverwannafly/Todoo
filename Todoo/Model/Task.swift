//
//  Model.swift
//  Todoo
//
//  Created by Shubham Anand on 17/07/18.
//  Copyright © 2018 Shubham Anand. All rights reserved.
//

import Foundation

class Task: Encodable {
    var title: String = ""
    var done: Bool = false
}
