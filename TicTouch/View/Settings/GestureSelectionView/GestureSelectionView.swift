import SwiftUI

struct GestureSelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("selectedGesture") private var selectedGesture: String = "Button"
    
    private var gestureOptions: [String] {[
        "Button",
        "Voice"
    ]}
    
    var body: some View {
        VStack(spacing: 20) {
            Text(NSLocalizedString("", comment: ""))
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.sand)
                .cornerRadius(10)
            VStack(spacing: 10) {
                ForEach(gestureOptions, id: \.self) { option in
                    menuItem(title: option)
                        .padding(.horizontal, 10)
                }
            }
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text(Bundle.localizedString(forKey: "Done", comment: ""))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 340, height: 50)
                    .background(Color.greenVariant)
                    .cornerRadius(10)
                    .shadow(color: Color.greenVariant.opacity(0.5), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal, 20)
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.sand
                .ignoresSafeArea()
        )
    }
    
    private func menuItem(title: String) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                selectedGesture = title
            }
        }) {
            HStack {
                Image(systemName: gestureIcon(for: title))
                    .foregroundColor(selectedGesture == title ? Color.white : Color.black)
                    .padding(.trailing, 10)
                Text(title)
                    .foregroundColor(selectedGesture == title ? Color.white : Color.black)
                    .font(.subheadline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(selectedGesture == title ? Color.greenVariant.opacity(0.75) : Color.sand.opacity(0.5))
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
    
    private func gestureIcon(for title: String) -> String {
        switch title {
        case "Button":
            return "hand.tap.fill"
        case "Voice":
            return "mic.fill"
        default:
            return "questionmark"
        }
    }
}
