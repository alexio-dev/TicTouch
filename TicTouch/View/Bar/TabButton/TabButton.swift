import SwiftUI

struct TabButton: View {
    @Binding var selectedTab: Tab
    private var isSelected: Bool { selectedTab == tab }
    var namespace : Namespace.ID
    let tab : Tab
    
    var body: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.25)) {
                selectedTab = tab
            }
        }) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(Color.greenVariant)
                        .shadow(radius: 10)
                        .matchedGeometryEffect(id: "SelectedTab", in: namespace)
                        .offset(y: -20)
                }
                
                Image(systemName: tab.icon)
                    .font(.system(size: 23, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(isSelected ? 1 : 0.8)
                    .offset(y: isSelected ? -20 : 0)
                    .animation(.spring(), value: selectedTab)
            }
            .frame(width: 65, height: 65)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
