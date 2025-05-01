import Foundation
import SwiftUI

func getArray() -> [TicData] {
    let calendar = Calendar.current
    let startDate = calendar.date(from: DateComponents(year: 2024, month: 3, day: 18))!
    let endDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 17))!
    var dataArray: [TicData] = []
    
    for _ in 1...500 {
        let randomTimeInterval = TimeInterval.random(in: 0...(endDate.timeIntervalSince(startDate)))
        let randomDate = startDate.addingTimeInterval(randomTimeInterval)
        let managedTics = Int.random(in: 0...30)
        let notManagedTics = Int.random(in: 0...30)
        let duration = Int.random(in: 60...1200)

        let exercise = exercises.randomElement()!
        
        let touretteData = TicData(
            date: randomDate,
            duration: duration,
            managedTics: managedTics,
            notManagedTics: notManagedTics,
            exercise: exercise
        )
        
        dataArray.append(touretteData)
    }
    
    TicCache.shared.saveData(dataArray, filename: "tourette_sessions.json")
    
    return dataArray
}

func getDate(from touretteDataArray: [TicData]) -> [Date] {
    let calendar = Calendar.current

    let uniqueDates = Set(touretteDataArray.map {
        calendar.startOfDay(for: $0.realDate)
    })
    
    var dateArray = Array(uniqueDates).sorted(by: >)
    let today = calendar.startOfDay(for: Date())
    
    if dateArray.first != today {
        dateArray.insert(today, at: 0)
    }
    
    return dateArray
}

var data = TicCache.shared.loadData(filename: "tourette_sessions.json") ?? []
let array = getDate(from: data)
