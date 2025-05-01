import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @AppStorage("name") private var name: String = ""
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                TabView(selection: $currentPage) {
                    InformationPage(
                        image: "Happiness",
                        title: Bundle.localizedString(forKey: "FirstPageTitle", comment: ""),
                        description: Bundle.localizedString(forKey: "FirstPageDescription", comment: "")
                    )
                    .tag(0)
                    
                    InformationPage(
                        image: "Start",
                        title: Bundle.localizedString(forKey: "SecondPageTitle", comment: ""),
                        description: Bundle.localizedString(forKey: "SecondPageDescription", comment: "")
                    )
                    .tag(1)
                    
                    InformationPage(
                        image: "Select",
                        title: Bundle.localizedString(forKey: "ThirdPageTitle", comment: ""),
                        description: Bundle.localizedString(forKey: "ThirdPageDescription", comment: "")
                    )
                    .tag(2)
                    
                    InformationPage(
                        image: "Dumbbell",
                        title: Bundle.localizedString(forKey: "FourthPageTitle", comment: ""),
                        description: Bundle.localizedString(forKey: "FourthPageDescription", comment: "")
                    )
                    .tag(3)
                    
                    InformationPage(
                        image: "Analysis",
                        title: Bundle.localizedString(forKey: "FifthPageTitle", comment: ""),
                        description: Bundle.localizedString(forKey: "FifthPageDescription", comment: "")
                    )
                    .tag(4)
                    
                    InsertPage()
                        .tag(5)
                }
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                Spacer(minLength: 20)
                
                ControlView(currentPage: $currentPage)
                    .padding(.top, -35)
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                    if currentPage == 5 && !name.isEmpty {
                        Button(action: {
                            isFirstTime = false
                        }) {
                            Image(systemName: "checkmark.circle")
                                .font(.title)
                                .foregroundColor(Color.greenVariant)
                        }
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    }
                }
                Spacer()
            }
        }
        .background(Color.sand)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
