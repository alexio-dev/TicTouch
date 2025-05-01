import SwiftUI
import Combine

class ExercisesManager: ObservableObject {
    @Published var exercises: [Exercises] = [
        Exercises(bodyPart: Bundle.localizedString(forKey: "Head", comment:  "Body part name"), exercise: Bundle.localizedString(forKey: "TenseNeckDesc", comment: "Neck Exercise Description"), titleExercise: Bundle.localizedString(forKey: "NeckEx", comment: "Title for neck exercise"), url: "firstHead"),
        Exercises(bodyPart:  Bundle.localizedString(forKey:"Head", comment: "Body part name"), exercise:  Bundle.localizedString(forKey:"ChinChest", comment: "Tense Neck Exercise Description"), titleExercise:  Bundle.localizedString(forKey:"TenseNeck", comment: "Tense Neck Exercise"), url: "secondHead"),
        Exercises(bodyPart:  Bundle.localizedString(forKey:"Eye", comment: "Body part name"), exercise:  Bundle.localizedString(forKey:"FocusBlink", comment: "Eye exercise description"), titleExercise:  Bundle.localizedString(forKey:"EyeEx", comment: "Eye Exercise title"), url: "firstEyes"),
        Exercises(bodyPart: NSLocalizedString("Eye", comment: "Body part name"), exercise: NSLocalizedString("BrowBreathe", comment: "Eyebrow contraction exercise description"), titleExercise: NSLocalizedString("BrowCont", comment: "Eyebrow contraction title"), url: "secondEyes"),
        Exercises(bodyPart: NSLocalizedString("Nose", comment: "Body part name"), exercise: NSLocalizedString("InhaleExhale", comment: "Nasal breathing exercise description"), titleExercise: NSLocalizedString("NasalBreath", comment: "Nasal breathing title"), url: "firstNose"),
        Exercises(bodyPart: NSLocalizedString("Nose", comment: "Body part name"), exercise: NSLocalizedString("PullNose", comment: "Nose tension exercise description"), titleExercise: NSLocalizedString("NoseTense", comment: "Nose tension title"), url: "secondNose"),
        Exercises(bodyPart: NSLocalizedString("Hand", comment: "Body part name"), exercise: NSLocalizedString("HandsStomach", comment: "Hand clasp exercise description"), titleExercise: NSLocalizedString("HandClasp", comment: "Hand Clasp title"), url: "fourthHand"),
        Exercises(bodyPart: NSLocalizedString("Hand", comment: "Body part name"), exercise: NSLocalizedString("HandsLegs", comment: "Hand exercise description"), titleExercise: NSLocalizedString("HandEx", comment: "Hand Exercise title"), url: "firstHand"),
        Exercises(bodyPart: NSLocalizedString("Hand", comment: "Body part name"), exercise: NSLocalizedString("FistsPress", comment: "Tight fists exercise description"), titleExercise: NSLocalizedString("TightFists", comment: "Tight Fists title"), url: "secondHand"),
        Exercises(bodyPart: NSLocalizedString("Leg", comment: "Body part name"), exercise: NSLocalizedString("HeelsFloor", comment: "Leg exercise description"), titleExercise: NSLocalizedString("LegEx", comment: "Leg Exercise title"), url: "firstLeg"),
        Exercises(bodyPart: NSLocalizedString("Leg", comment: "Body part name"), exercise: NSLocalizedString("KneesTogether", comment: "Tight knees exercise description"), titleExercise: NSLocalizedString("TightKnees", comment: "Tight Knees title"), url: "secondLeg"),
        Exercises(bodyPart: NSLocalizedString("Leg", comment: "Body part name"), exercise: NSLocalizedString("StandHeels", comment: "Heels exercise description"), titleExercise: NSLocalizedString("HeelsWeight", comment: "Weight on Heels title"), url: "thirdLeg"),
        Exercises(bodyPart: NSLocalizedString("Mouth", comment: "Body part name"), exercise: NSLocalizedString("JawLips", comment: "Jaw clenching exercise description"), titleExercise: NSLocalizedString("JawClench", comment: "Jaw Clenching title"), url: "secondMounth"),
        Exercises(bodyPart: NSLocalizedString("Mouth", comment: "Body part name"), exercise: NSLocalizedString("CloseTeeth", comment: "Lip closure exercise description"), titleExercise: NSLocalizedString("LipClose", comment: "Lip Closure title"), url: "thirdMounth"),
        Exercises(bodyPart: NSLocalizedString("Arm", comment: "Body part name"), exercise: NSLocalizedString("FingersArms", comment: "Interlaced arms exercise description"), titleExercise: NSLocalizedString("InterlacedArms", comment: "Interlaced Arms title"), url: "firstArm"),
        Exercises(bodyPart: NSLocalizedString("Shoulder", comment: "Body part name"), exercise: NSLocalizedString("ElbowsHips", comment: "Thigh push exercise description"), titleExercise: NSLocalizedString("ThighPush", comment: "Thigh Push title"), url: "firstShoulder"),
        Exercises(bodyPart:  Bundle.localizedString(forKey:"Shoulder", comment: "Body part name"), exercise:  Bundle.localizedString(forKey:"ShouldersDown", comment: "Lowered shoulders exercise description"), titleExercise:  Bundle.localizedString(forKey:"LowShoulders", comment: "Lowered Shoulders title"), url: "secondShoulder"),
        Exercises(bodyPart:  Bundle.localizedString(forKey:"Foot", comment: "Body part name"), exercise:  Bundle.localizedString(forKey:"BendKnees", comment: "Crossed feet position exercise description"), titleExercise:  Bundle.localizedString(forKey:"CrossFeet", comment: "Crossed Feet Position title"), url: "firstFeet")
    ]
    
    @AppStorage("selectedLanguage") var language: String = Locale.preferredLanguages.first ?? ""
    private var cancellable: AnyCancellable?
    
    init() {
        updateExercises()
        
        cancellable = NotificationCenter.default.publisher(for: .languageChanged)
            .sink { _ in
                self.language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "English"
                self.updateExercises()
            }
    }
    
    func updateExercises() -> [Exercises]{
        Bundle.setLanguage(language)
        
        exercises = [
            Exercises(bodyPart: Bundle.localizedString(forKey: "Head", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "TenseNeckDesc", comment: "Neck Exercise Description"), titleExercise: Bundle.localizedString(forKey: "NeckEx", comment: "Title for neck exercise"), url: "firstHead"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Head", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "ChinChest", comment: "Tense Neck Exercise Description"), titleExercise: Bundle.localizedString(forKey: "TenseNeck", comment: "Tense Neck Exercise"), url: "secondHead"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Eye", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "FocusBlink", comment: "Eye exercise description"), titleExercise: Bundle.localizedString(forKey: "EyeEx", comment: "Eye Exercise title"), url: "firstEyes"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Eye", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "BrowBreathe", comment: "Eyebrow contraction exercise description"), titleExercise: Bundle.localizedString(forKey: "BrowCont", comment: "Eyebrow contraction title"), url: "secondEyes"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Nose", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "InhaleExhale", comment: "Nasal breathing exercise description"), titleExercise: Bundle.localizedString(forKey: "NasalBreath", comment: "Nasal breathing title"), url: "firstNose"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Nose", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "PullNose", comment: "Nose tension exercise description"), titleExercise: Bundle.localizedString(forKey: "NoseTense", comment: "Nose tension title"), url: "secondNose"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Hand", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "HandsStomach", comment: "Hand clasp exercise description"), titleExercise: Bundle.localizedString(forKey: "HandClasp", comment: "Hand Clasp title"), url: "fourthHand"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Hand", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "HandsLegs", comment: "Hand exercise description"), titleExercise: Bundle.localizedString(forKey: "HandEx", comment: "Hand Exercise title"), url: "firstHand"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Hand", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "FistsPress", comment: "Tight fists exercise description"), titleExercise: Bundle.localizedString(forKey: "TightFists", comment: "Tight Fists title"), url: "secondHand"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Leg", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "HeelsFloor", comment: "Leg exercise description"), titleExercise: Bundle.localizedString(forKey: "LegEx", comment: "Leg Exercise title"), url: "firstLeg"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Leg", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "KneesTogether", comment: "Tight knees exercise description"), titleExercise: Bundle.localizedString(forKey: "TightKnees", comment: "Tight Knees title"), url: "secondLeg"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Leg", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "StandHeels", comment: "Heels exercise description"), titleExercise: Bundle.localizedString(forKey: "HeelsWeight", comment: "Weight on Heels title"), url: "thirdLeg"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Mouth", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "JawLips", comment: "Jaw clenching exercise description"), titleExercise: Bundle.localizedString(forKey: "JawClench", comment: "Jaw Clenching title"), url: "secondMounth"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Mouth", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "CloseTeeth", comment: "Lip closure exercise description"), titleExercise: Bundle.localizedString(forKey: "LipClose", comment: "Lip Closure title"), url: "thirdMounth"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Arm", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "FingersArms", comment: "Interlaced arms exercise description"), titleExercise: Bundle.localizedString(forKey: "InterlacedArms", comment: "Interlaced Arms title"), url: "firstArm"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Shoulder", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "ElbowsHips", comment: "Thigh push exercise description"), titleExercise: Bundle.localizedString(forKey: "ThighPush", comment: "Thigh Push title"), url: "firstShoulder"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Shoulder", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "ShouldersDown", comment: "Lowered shoulders exercise description"), titleExercise: Bundle.localizedString(forKey: "LowShoulders", comment: "Lowered Shoulders title"), url: "secondShoulder"),
            Exercises(bodyPart: Bundle.localizedString(forKey: "Foot", comment: "Body part name"), exercise: Bundle.localizedString(forKey: "BendKnees", comment: "Crossed feet position exercise description"), titleExercise: Bundle.localizedString(forKey: "CrossFeet", comment: "Crossed Feet Position title"), url: "firstFeet")
        ]
        
        return exercises
    }
}
