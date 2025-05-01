import Combine
import SwiftUI
import AVFoundation

var player: AVAudioPlayer?
var transcript: String = ""

func playSound(soundName : String) {
    guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        
        guard let player = player else { return }
        
        player.play()
        
    } catch let error {
        print(error.localizedDescription)
    }
}

struct HabitReversalTrainingTimer: View {
    @AppStorage("selectedGesture") private var selectedGesture: String = "Button"
    @EnvironmentObject var exerciseManager: ExercisesManager
    @State private var scaleM: CGFloat = 1.0
    @State private var timerSubscription: Cancellable?
    @State var counter: Int = 0
    @State private var isRunning: Bool = false
    @State var countTo: Int = 30
    @State private var ticManaged: Int = 0
    @State private var ticNotManaged: Int = 0
    @State private var setTimer = true
    @State private var hasSpoken = false
    @State private var micColor: Color = .black
    
    @Binding var navPath : NavigationPath
    
    private var speechRecognizer = SpeechRecognizer()
    let selectedExercise: Exercises
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(exercise: Exercises, path: Binding<NavigationPath>) {
        self.selectedExercise = exercise
        self._navPath = path
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            Text(Bundle.localizedString(forKey: selectedExercise.titleExercise, comment: ""))
                .font(.title)
                .fontWeight(.bold)
            
            Text(Bundle.localizedString(forKey: selectedExercise.exercise, comment: ""))
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.top, 15)
                .frame(width: 350)
            
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(
                            Circle().stroke(Color.greenVariant, lineWidth: 25)
                        )
                    
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 250, height: 250)
                        .overlay(
                            Circle().trim(from: 0, to: progress())
                                .stroke(
                                    style: StrokeStyle(
                                        lineWidth: 25,
                                        lineCap: .round,
                                        lineJoin: .round
                                    )
                                )
                                .foregroundColor(completed() ? Color.orange : Color.emerald)
                                .rotationEffect(.degrees(-90))
                        )
                    
                    Clock(counter: counter, countTo: countTo)
                }
            }
            .padding(.top, 40)
            .onReceive(timer) { _ in
                if isRunning {
                    if counter < countTo {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            counter += 1
                        }
                    } else {
                        isRunning = false
                    }
                }
            }
            
            
            
            if setTimer {
                VStack {
                    Text(Bundle.localizedString(forKey: "SetTimer", comment: ""))
                        .font(.headline)
                    
                    Stepper(value: $countTo, in: 30...90000, step: 30) {
                        Text("\(countTo) " + Bundle.localizedString(forKey: "Seconds", comment: "").lowercased())
                    }
                    .padding()
                    .onChange(of: countTo) {
                        vibrate(4)
                    }
                }
                .padding(.top, 20)
                
                
                Button(Bundle.localizedString(forKey: "Start", comment: "")) {
                    vibrate()
                    counter = 0
                    isRunning = true
                    setTimer = false
                }
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(
                    Rectangle()
                        .fill(.greenVariant)
                        .frame(width: 120, height: 50)
                        .cornerRadius(8)
                )
                .padding(.top, 20)
            }
            
            if counter < countTo && !setTimer {
                
                switch selectedGesture {
                case "Voice":
                    HStack {
                        Image(systemName: "microphone.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(micColor)
                            .onAppear {
                                speechRecognizer.resetTranscript()
                                speechRecognizer.startTranscribing()
                                
                            }
                            .onChange(of: speechRecognizer.transcript) {
                                transcript = speechRecognizer.transcript.lowercased()
                                if transcript.contains("green") || transcript.contains("verde") {
                                    ticManaged += 1
                                    playSound(soundName: "correctSounds")
                                    animateMicColor(to: .green)
                                }
                                else if transcript.contains("red") || transcript.contains("rosso") || transcript.contains("russo") {
                                    ticNotManaged += 1
                                    animateMicColor(to: .red)
                                }
                                speechRecognizer.resetTranscript()
                                speechRecognizer.startTranscribing()
                            }
                    }
                    
                default:
                    HStack {
                        ForEach(1...2, id: \.self) { i in
                            Button {
                                vibrate(3)
                                
                                if i == 1 {
                                    ticManaged += 1
                                    print("Tic managed: \(ticManaged)")
                                    playSound(soundName: "correctSounds")
                                } else {
                                    ticNotManaged += 1
                                    print("Tic not managed: \(ticNotManaged)")
                                }
                                
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(i == 1 ? .greenVariant : .red)
                                        .frame(width: 100, height: 50)
                                        .cornerRadius(8)
                                    
                                    Image(systemName: i == 1 ? "checkmark" : "xmark")
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(width: 100, height: 50)
                            .padding(.trailing, i == 1 ? 100 : 0)
                        }
                    }
                    .padding(.top, 40)
                }
                
                
            }
            
            if counter >= countTo  && !setTimer {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text(Bundle.localizedString(forKey:"MeditationSuccess", comment: ""))
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .scaleEffect(scaleM)
                            .onAppear {
                                withAnimation(
                                    Animation.easeInOut(duration: 0.8)
                                        .repeatForever(autoreverses: true)
                                ) {
                                    scaleM = 1.2
                                }
                            }
                            .padding(.top, 40)
                        
                        
                        HStack {
                            Rectangle()
                                .foregroundColor(.green)
                                .opacity(0.3)
                                .cornerRadius(4)
                                .frame(width: 150, height: 50)
                                .overlay(
                                    VStack(alignment: .center) {
                                        Text(Bundle.localizedString(forKey: "Managed", comment: "")).fontWeight(.bold)
                                        Text("\(ticManaged)")
                                    }
                                )
                            
                            Rectangle()
                                .foregroundColor(.red)
                                .opacity(0.3)
                                .cornerRadius(4)
                                .frame(width: 150, height: 50)
                                .overlay(
                                    VStack(alignment: .center) {
                                        Text(Bundle.localizedString(forKey: "NotManaged", comment: "")).fontWeight(.bold)
                                        Text("\(ticNotManaged)")
                                    }
                                )
                        }
                        .onAppear() {
                            let newElement = TicData(date: Date(), duration: countTo, managedTics: ticManaged, notManagedTics: ticNotManaged, exercise: selectedExercise)
                            data.append(newElement)
                            TicCache.shared.saveData(data, filename: "tourette_sessions.json")
                            
                            if selectedGesture == "Voice" {
                                speechRecognizer.stopTranscribing()
                            }
                        }
                        .padding(.top, 10)
                        
                        Button {
                            vibrate()
                            
                            navPath.removeLast()
                            
                        } label : {
                            ZStack {
                                
                                Rectangle()
                                    .fill(.greenVariant)
                                    .cornerRadius(8)
                                    .frame(width: 250, height: 50)
                                
                                Text(Bundle.localizedString(forKey: "GoBack", comment: ""))
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 250, height: 50)
                        .padding(.top, 30)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.sand)
        .navigationBarBackButtonHidden(true)
    }
    
    
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return CGFloat(counter) / CGFloat(countTo)
    }
    
    func animateMicColor(to color: Color) {
        withAnimation(.easeInOut(duration: 0.5)) {
            micColor = color
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                micColor = .black
            }
        }
    }
    
}
