//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Cecilia Chen on 9/22/23.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    //Sample Tasks
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate: .init(timeIntervalSince1970: 1641645497)),
        Task(taskTitle: "Design Review", taskDescription: "Review new app design with design team", taskDate: .init(timeIntervalSince1970: 1641731897)),
        Task(taskTitle: "Code Refactoring", taskDescription: "Refactor the authentication module", taskDate: .init(timeIntervalSince1970: 1641818297)),
        Task(taskTitle: "Client Call", taskDescription: "Discuss project updates with the client", taskDate: .init(timeIntervalSince1970: 1641904697)),
        Task(taskTitle: "Team Lunch", taskDescription: "Monthly team building lunch", taskDate: .init(timeIntervalSince1970: 1641991097)),
        // A task for today
        Task(taskTitle: "Team Meeting",
             taskDescription: "Discuss team task for the day",
             taskDate: Date()),
        
        // A task for 2 hours before current time
        Task(taskTitle: "Preparation Meeting",
             taskDescription: "Prepare for the main meeting",
             taskDate: Calendar.current.date(byAdding: .hour, value: -2, to: Date())!),

        // A task for 3 hours after current time
        Task(taskTitle: "Design Brainstorming",
             taskDescription: "Brainstorming session for new design ideas",
             taskDate: Calendar.current.date(byAdding: .hour, value: 3, to: Date())!),

        // A task for 6 hours after current time
        Task(taskTitle: "Client Feedback Review",
             taskDescription: "Review and analyze feedback received from the client on the latest deliverables to understand their perspective",
             taskDate: Calendar.current.date(byAdding: .hour, value: 6, to: Date())!),
        
        // A task for tomorrow
        Task(taskTitle: "Design Review",
             taskDescription: "Review new app design with design team",
             taskDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!),
        // A task for two days ago
        Task(taskTitle: "Code Refactoring",
             taskDescription: "Refactor the authentication module",
             taskDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        
        // A task for three days from today
        Task(taskTitle: "Client Call",
             taskDescription: "Discuss project updates with the client",
             taskDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!),
        
    ]
    
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filltering Today's Tasks
    @Published var filteredTasks: [Task]?
    
    // MARK: Initializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    // MARK: Filter Today's Tasks
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted { task1, task2 in
                    return task2.taskDate < task1.taskDate
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else {
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                currentWeek.append(weekday)
            }
        }
    }
    
    // MARK: Extracting Date
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking if the currentHour is task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let currentHour = calendar.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
