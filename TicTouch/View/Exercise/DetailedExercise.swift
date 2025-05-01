import SwiftUI
import AVFoundation

struct DetailedExercise: View {
    let exercise : Exercises
    
    
    init(exerciseDetails: Exercises) {
        self.exercise = exerciseDetails
    }
    
    var body: some View {
        VStack{
            Text(Bundle.localizedString(forKey: exercise.titleExercise, comment: ""))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
            Text(Bundle.localizedString(forKey: exercise.exercise, comment: ""))
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.top, 15)
            
            VideoPlayer(name : exercise.url)
        }
        .padding(.top, 25)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.sand)
    }
}
