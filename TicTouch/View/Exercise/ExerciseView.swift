import SwiftUI

struct ExerciseView: View {
    @Binding var bodyPartName: String
    @Binding var navigationPath : NavigationPath
    
    @State private var isSheetPresented = false
    @State private var firstSelectedExercise: Exercises?
    @State private var secondSelectedExercise: Exercises?
    @State private var canNavigate = false
    
    @EnvironmentObject var exerciseManager: ExercisesManager
    
    init(bodyPart: Binding<String>, path : Binding<NavigationPath>) {
        self._bodyPartName = bodyPart
        self._navigationPath = path
    }
    
    var body: some View {
        let filteredExercises = exercises.filter {
            $0.bodyPart == bodyPartName
        }
        
        ScrollView(.vertical) {
            VStack {
                Text(Bundle.localizedString(forKey: bodyPartName, comment: ""))
                    .padding()
                    .frame(width: 200, height: 50)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text(Bundle.localizedString(forKey: "ChooseExercise", comment: ""))
                    .padding(.top, 20)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 250, height: 45, alignment: .center)
                    .font(.title3)
                
                if filteredExercises.isEmpty {
                    Text("No exercises for \(bodyPartName)")
                } else {
                    VStack(spacing: 20) {
                        ForEach(filteredExercises) { exercise in
                            ZStack(alignment: .center) {
                                Rectangle()
                                    .frame(width: 340, height: 160)
                                    .foregroundColor(.emerald)
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                    .overlay(
                                        Text(Bundle.localizedString(forKey: exercise.titleExercise, comment: ""))
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.center)
                                            .offset(x: 10, y: -10)
                                    )
                                
                                HStack {
                                    Button {
                                        vibrate()
                                        secondSelectedExercise = exercise
                                        navigationPath.append("meditation")
                                        canNavigate.toggle()
                                    } label: {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.greenVariant)
                                                .cornerRadius(8)
                                                .frame(width: 130, height: 45, alignment: .center)
                                            
                                            Text(Bundle.localizedString(forKey: "Start", comment: ""))
                                                .foregroundColor(.white)
                                                .padding()
                                                .fontWeight(.bold)
                                        }
                                    }
                                    .position(x: 30, y: 20)
                                    .frame(width: 130, height: 45)
                                    .offset(x: 130, y: -14)
                                    
                                    Spacer()
                                    
                                    Button {
                                        vibrate(0)
                                        firstSelectedExercise = exercise
                                    } label: {
                                        Image("information")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(
                                                Circle()
                                                    .fill(Color.greenVariant)
                                                    .frame(width: 40, height: 40, alignment: .center)
                                            )
                                    }
                                    .frame(width: 30, height: 30)
                                    .position(x: 150, y: -30)
                                }
                                .frame(width: 300)
                                .offset(y: 60)
                            }
                        }
                    }
                    .padding(.top, 25)
                    .padding(.bottom, 40)
                }
            }
            
        }
        .scrollIndicators(.visible, axes: .vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.sand)
        
        .navigationDestination(isPresented: $canNavigate) {
            if let exercise = secondSelectedExercise {
                MeditationTimer(exercise: exercise, navPath : $navigationPath)
            }
        }
        .sheet(item: $firstSelectedExercise) { exerciseDetails in
            DetailedExercise(exerciseDetails: exerciseDetails)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.8), .large])
        }
    }
}



