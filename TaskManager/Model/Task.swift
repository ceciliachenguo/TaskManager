//
//  Task.swift
//  TaskManager
//
//  Created by Cecilia Chen on 9/22/23.
//

import Foundation

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
