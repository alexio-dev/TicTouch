import SwiftUI

struct ControlView: View {
    @Binding var currentPage: Int

    var body: some View {
        HStack {
            Button(action: {
                if currentPage > 0 {
                    currentPage -= 1
                }
            }) {
                Image(systemName: "chevron.backward.circle")
                    .font(.title)
                    .foregroundColor(currentPage > 0 ? Color.greenVariant : Color.gray)
            }
            .disabled(currentPage == 0)

            Spacer()

            Button(action: {
                if currentPage < 5 {
                    currentPage += 1
                }
            }) {
                Image(systemName: "chevron.forward.circle")
                    .font(.title)
                    .foregroundColor(currentPage < 5 ? Color.greenVariant : Color.gray)
            }
            .disabled(currentPage >= 5)
        }
        .padding(.horizontal, 20)
    }
}
