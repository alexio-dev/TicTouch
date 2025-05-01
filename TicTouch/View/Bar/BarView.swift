import SwiftUI

struct BarView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.emerald)
                    .shadow(color: .gray.opacity(0.35), radius: 10, x: 0, y: 5)
                
                LayoutView(selectedTab: $selectedTab)
            }
            .frame(height: 70)
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}







