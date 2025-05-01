/**
 This file starts TouretteApp Project, it redirects in WelcomeView, if solution is opened for first time;
 else it redirects in ContentView
 
 This project is under Common GPL v3.0 License - all rights reserved.
 A Project of:
 - Alessio A. [Coordinator]
 - Benedetta Z.
 - Gian Marco T.
 - Giovanni G.
 */

import SwiftUI

@main
struct TouretteApp: App {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    @StateObject private var exerciseManager = ExercisesManager()
    
    init() {
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            isFirstTime = true
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                WelcomeView()
            } else {
                ContentView()
                    .environmentObject(exerciseManager)
            }
        }
    }
}
