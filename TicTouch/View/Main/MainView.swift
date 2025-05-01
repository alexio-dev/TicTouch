import SwiftUI
import SpriteKit

struct MainView: View {
    @State private var partName: String = ""
    @State private var path = NavigationPath()
    @State private var exercises: [Exercises] = []
    
    @EnvironmentObject var exerciseManager: ExercisesManager
    
    var scene: SKScene {
        let scene = BodyScene(size: CGSize(width: 360, height: 720))
        scene.scaleMode = .resizeFill
        scene.backgroundColor = UIColor.sand
        scene.partName = $partName
        scene.navPath = $path
        
        return scene
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack(path : $path) {
                VStack {
                    Spacer().frame(height: geometry.size.height * 0.002)
                    SpriteView(scene: scene)
                        .ignoresSafeArea(.all)
                }
                .navigationDestination(for: String.self ) { _ in
                    ExerciseView(bodyPart: $partName, path: $path)
                    
                }
                .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                .background(Color.sand)
            }
            .ignoresSafeArea()
            .accentColor(.greenVariant)
        }
        .onAppear() {
            exerciseManager.updateExercises()
        }
    }
    
}
