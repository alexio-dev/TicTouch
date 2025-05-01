import Foundation

class TicData: Identifiable, Codable {
    var id: UUID = UUID()
    var realDate: Date
    var managedTics, notManagedTics: Int
    var duration: Int
    var exercise: Exercises
    
    init(date: Date, duration: Int, managedTics: Int, notManagedTics: Int, exercise: Exercises) {
        self.realDate = date
        self.managedTics = managedTics
        self.notManagedTics = notManagedTics
        self.duration = duration
        self.exercise = exercise
    }
}
