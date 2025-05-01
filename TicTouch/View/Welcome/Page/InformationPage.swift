import SwiftUI

struct InformationPage: View {
    var image: String
    var title: String
    var description: String

    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding()

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
