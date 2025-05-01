import SwiftUI
import PhotosUI

struct SettingsView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var showGestureSheet: Bool = false
    @State private var isEditing: Bool = false
    @State private var tempName: String = ""
    
    @AppStorage("name") private var name: String = Bundle.localizedString(forKey: "YourName", comment: "")
    
    @AppStorage("language") private var language: String = Locale.current.identifier

    var body: some View {
        NavigationView {
            ZStack {
                Color.sand.ignoresSafeArea()
                Form {
                    Section(header: Text(Bundle.localizedString(forKey: "Profile", comment: ""))
                        .font(.headline)
                        .foregroundColor(Color.black)) {
                            VStack {
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    ZStack {
                                        if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 90, height: 90)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle().stroke(Color.brown, lineWidth: 3)
                                                )
                                        } else {
                                            Circle()
                                                .fill(Color.gray.opacity(0.4))
                                                .frame(width: 90, height: 90)
                                                .overlay(
                                                    Text(name.first?.uppercased() ?? "")
                                                        .font(.title)
                                                        .foregroundColor(.white))
                                        }
                                        Circle()
                                            .fill(Color.black.opacity(0.3))
                                            .frame(width: 90, height: 90)
                                            .overlay(
                                                Text(name.first?.uppercased() ?? "")
                                                    .foregroundColor(.white)
                                                    .font(.largeTitle)
                                            )
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onChange(of: selectedItem) { newItem in
                                    Task {
                                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                            self.selectedImageData = data
                                        }
                                    }
                                }
                                Spacer().frame(height: 20)
                                HStack {
                                    Spacer()
                                    if isEditing {
                                        TextField(Bundle.localizedString(forKey: "EnterName", comment: ""), text: $tempName)
                                            .multilineTextAlignment(.center)
                                            .font(.title3)
                                            .padding(8)
                                            .background(Color.brown.opacity(0.1))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.brown, lineWidth: 2)
                                            )
                                    } else {
                                        Text(name)
                                            .font(.title3)
                                            .fontWeight(.medium)
                                            .foregroundColor(.black)
                                    }
                                    Button(action: {
                                        if isEditing{
                                            name = tempName
                                        }
                                        else {
                                            tempName = name
                                        }
                                        isEditing.toggle()
                                    }) {
                                        Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil")
                                            .foregroundColor(.brown)
                                            .font(.title2)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.top, 10)
                        }
                        .listRowBackground(Color.sand.opacity(0.6))
                    
                    Section(header: Text(Bundle.localizedString(forKey: "Language", comment: ""))
                        .font(.headline)
                        .foregroundColor(Color.black)) {
                        Picker(Bundle.localizedString(forKey: "SelectLang", comment: ""), selection: $language) {
                                Text(Bundle.localizedString(forKey: "English", comment: ""))
                                    .tag("en")
                                Text(Bundle.localizedString(forKey: "Italian", comment: ""))
                                    .tag("it")
                            }
                            .foregroundColor(Color.black)
                            .pickerStyle(SegmentedPickerStyle())
                            .onChange(of: language) { newValue in
                                updateAppLanguage(to: newValue)
                            }
                            .padding(.vertical, 5)
                    }
                        .listRowBackground(Color.sand.opacity(0.6))
                    
                    Section(header: Text(Bundle.localizedString(forKey: "Gesture", comment: ""))
                        .font(.headline)
                        .foregroundColor(Color.black)) {
                            Button(Bundle.localizedString(forKey: "SelectGesture", comment: "")) {
                                showGestureSheet = true
                            }
                            .foregroundColor(Color.black)
                        }
                        .listRowBackground(Color.sand.opacity(0.6))
                }
                .scrollContentBackground(.hidden)
                .background(Color.sand)
            }
            .navigationTitle(Bundle.localizedString(forKey: "Profile", comment: ""))
            .sheet(isPresented: $showGestureSheet) {
                GestureSelectionView()
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
                    .presentationBackground(Color.sand)
            }
        }
        .background(Color.sand.ignoresSafeArea())
    }
    
    private func updateAppLanguage(to code: String) {
        language = code
        Bundle.setLanguage(code)
        NotificationCenter.default.post(name: .languageChanged, object: nil)
    }
}

extension Notification.Name {
    static let languageChanged = Notification.Name("languageChanged")
}
