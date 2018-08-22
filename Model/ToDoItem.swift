//
//  ToDoItem.swift
//  ToDo
//
//  Created by Tomas Sidenfaden on 7/5/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation

struct ToDoItem: Equatable {
    static func ==(lhs: ToDoItem, rhs: ToDoItem) -> Bool {
        if lhs.location != rhs.location {
            return false
        }
        if lhs.timestamp != rhs.timestamp {
            return false
        }
        if lhs.itemDescription != rhs.itemDescription {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        return true
    }
    
    let title: String
    let itemDescription: String?
    let timestamp: Double?
    let location: Location?
    
    init(title: String,
         itemDescription: String? = nil,
         timestamp: Double? = nil,
         location: Location? = nil) {
        self.title = title
        self.itemDescription = itemDescription
        self.timestamp = timestamp
        self.location = location
    }
    
    init?(dict: [String:Any]) {
        return nil
    }
    
    var plistDict: [String:Any] {
        return [:]
    }

}
