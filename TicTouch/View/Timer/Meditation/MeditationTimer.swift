import SwiftUI
import Combine

struct MeditationTimer: View {
    @Binding var navigationPath : NavigationPath
    
    @State private var offsetY: CGFloat = 0
    @State private var meditationTextTimer: Timer?
    @State private var currentTextIndex = 0
    @State private var showText = true
    @State private var scale: CGFloat = 1.0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var timerSubscription: Cancellable?
    @State private var timeRemaining = 0
    @State private var hasStopped = false
    @State private var hasTimerStarted: Bool = false
    @State private var  canNavigate = false
    @State private var countdownNumber = 3
    @State private var showNextNumber: Bool = true
    @State private var selectedExercise: Exercises?
    
    let meditationKeys: [String] = [
        "FirstMedText",
        "SecondMedText",
        "ThirdMedText",
        "FourthMedText"
    ]
    
    let exercise: Exercises
    
    init(exercise: Exercises, navPath : Binding<NavigationPath>) {
        self.exercise = exercise
        self._navigationPath = navPath
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    Spacer().frame(height : 30)
                    if countdownNumber > 0 {
                        Text("\(countdownNumber)")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .opacity(showNextNumber ? 1 : 0.5)
                            .animation(.easeInOut(duration: 0.8), value: showNextNumber)
                    } else {
                        if !hasStopped {
                            Text(Bundle.localizedString(forKey: meditationKeys[currentTextIndex], comment: ""))
                                .font(.title)
                                .offset(y: offsetY)
                                .opacity(showText ? 1 : 0)
                                .onAppear() {
                                    hasTimerStarted = true
                                    startMeditationTimer()
                                }
                                .animation(.easeInOut(duration: 1), value: offsetY)
                        } else {
                            Text(Bundle.localizedString(forKey: "MeditationSuccess", comment: ""))
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .scaleEffect(scale)
                                .onAppear {
                                    withAnimation(
                                        Animation.easeInOut(duration: 0.8)
                                            .repeatForever(autoreverses: true)
                                    ) {
                                        scale = 1.2
                                    }
                                }
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.2, alignment: .top)
                   
                Text(timeString(from: timeRemaining))
                    .font(.system(size: 100))
                    .padding()
                    .background(
                        Rectangle().fill(Color.emerald).cornerRadius(10)
                            .frame(width: 350, height: 150)
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                    .foregroundColor(.white)
                    .position(x: geometry.size.width / 2, y : geometry.size.height / 4)
                    .onReceive(timer) { _ in
                        timeRemaining += 1
                    }
                
                if hasTimerStarted {
                    Button(action: {
                        vibrate()
                        if !hasStopped {
                            timerSubscription?.cancel()
                            meditationTextTimer?.invalidate()
                            hasStopped = true
                        } else {
                            selectedExercise = exercise
                            navigationPath.append("hrt")
                            
                            canNavigate.toggle()
                        }
                    }) {
                        Text(hasStopped ? Bundle.localizedString(forKey: "MeditationContinue", comment: "") : "Stop")
                            .frame(width: geometry.size.width * 0.9, height: 80)
                            .background(Rectangle().fill(hasStopped ? .greenVariant : .red).cornerRadius(10))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                    .offset(y : -geometry.size.height * 0.15)
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
        }
        .onAppear() {
            
            showCountdownText()
        }
        .navigationDestination(isPresented: $canNavigate) {
            if let selectedExercise = selectedExercise {
                HabitReversalTrainingTimer(exercise: selectedExercise, path : $navigationPath)
            }
        }
        .background(.sand)
        .navigationBarBackButtonHidden(!hasStopped)
    }
    
    private func startMeditationTimer() {
        timeRemaining = 0
        timerSubscription = timer.connect()
        showComfortingTexts()
    }
    
    private func showCountdownText() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.8)) {
                showNextNumber = false
                countdownNumber -= 1
                showNextNumber = true
            }
            
            if countdownNumber <= 0 {
                timer.invalidate()
            }
        }
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func showComfortingTexts() {
        meditationTextTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                showText = false
                currentTextIndex = (currentTextIndex + 1) % meditationKeys.count
                showText = true
                offsetY += 50
                if currentTextIndex == 0 {
                    offsetY = 0
                }
            }
        }
    }
}
