import SwiftUI
import UIKit

func vibrate(_ level: Int = 2) {
    let style: UIImpactFeedbackGenerator.FeedbackStyle
    
    switch level {
    case 0:
        style = .soft
    case 1:
        style = .light
    case 2:
        style = .medium
    case 3:
        style = .heavy
    case 4:
        style = .rigid
    default:
        style = .medium 
    }
    
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.impactOccurred()
}
