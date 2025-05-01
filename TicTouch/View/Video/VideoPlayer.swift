import AVKit
import SwiftUI

struct VideoPlayer: View {
    let name: String
    
    var body: some View {
        if let path = Bundle.main.path(forResource: name, ofType: "mov") {
            let videoURL = URL(fileURLWithPath: path)
            let player = AVPlayer(url: videoURL)
            
            VStack {
                VideoPlayerController(player: player)
                    .frame(height: 500)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                    }
            }
        } else {
            Text("Error")
        }
    }
}
