import SwiftUI

enum GestureType: String {
    case voice
    case buttons
}

struct InsertPage: View {
    @AppStorage("gesture") private var gesture: String = GestureType.voice.rawValue
    @AppStorage("name") private var name: String = ""
    
    var body: some View {
        VStack {
            Text(Bundle.localizedString(forKey: "EnterName", comment: ""))
                .font(.title2)
                .foregroundColor(Color.black)
            
            TextField(
                Bundle.localizedString(forKey: "Name", comment: ""),
                text: $name
            )
            .multilineTextAlignment(.center)
            .font(.title3)
            .padding(8)
            .background(Color.brown.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.brown, lineWidth: 2)
            )
            
            HStack {
                Button(action: {
                    gesture = GestureType.voice.rawValue
                }) {
                    HStack {
                        Image(systemName: "mic.fill")
                        Text(Bundle.localizedString(forKey: "Voice", comment: ""))
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.greenVariant)
                    .cornerRadius(8)
                }
                
                Button(action: {
                    gesture = GestureType.buttons.rawValue
                }) {
                    HStack {
                        Image(systemName: "hand.tap.fill")
                        Text(Bundle.localizedString(forKey: "Button", comment: ""))
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.greenVariant)
                    .cornerRadius(8)
                }
            }
            .padding(.top, 8)
        }
        .padding()
    }
}
