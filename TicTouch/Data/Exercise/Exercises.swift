import Foundation

struct Exercises : Identifiable, Hashable, Equatable, Codable {
    var id  : UUID = UUID()
    var bodyPart : String
    var exercise : String
    var titleExercise : String
    var url : String
    
    init(bodyPart: String, exercise: String, titleExercise: String, url: String) {
        self.bodyPart = bodyPart
        self.exercise = exercise
        self.titleExercise = titleExercise
        self.url = url
    }
}
