import SwiftUI

struct LayoutView: View {
    @Binding var selectedTab: Tab
    @Namespace var namespace
    
    var body: some View {
        HStack(spacing: 40) {
            ForEach(Tab.allCases) { tab in
                TabButton(selectedTab: $selectedTab, namespace: namespace, tab: tab)
            }
        }
        .padding(.horizontal, 20)
    }
}
