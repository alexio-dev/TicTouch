import SwiftUI
import Foundation

struct DataView: View {
    @State private var selectedDate: Date = Date()
    @State private var isDatePickerPresented: Bool = false
    @State private var tapCount = 0
    private let calendar = Calendar.current
    private var filteredData: [TicData] {
        data.filter { calendar.isDate($0.realDate, equalTo: selectedDate, toGranularity: .day) }
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    private let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            Spacer(minLength: UIScreen.main.bounds.width/2 - 60)
                            ForEach(array, id: \.self) { date in
                                Button(action: {
                                    if selectedDate != date {
                                        selectedDate = date
                                    } else {
                                        tapCount += 1
                                        if tapCount >= 2 {
                                            selectedDate = array[0]
                                            tapCount = 0
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            tapCount = 0
                                        }
                                    }
                                }) {
                                    Text(formatter.string(from: date))
                                        .foregroundColor(selectedDate == date ? .white : .black)
                                        .padding()
                                        .background(selectedDate == date ? Color.emerald : Color.gray.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                .id(date)
                            }
                        }
                    }
                    .frame(height: 60)
                    .environment(\.layoutDirection, .rightToLeft)
                    .onAppear() {
                        selectedDate = array.first ?? Date()
                    }
                    .onChange(of: selectedDate) {
                        withAnimation {
                            proxy.scrollTo(nearestDay(from: selectedDate, in: array), anchor: .center)
                        }
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ChartView(selectedDate: $selectedDate)
                        
                        if filteredData.isEmpty {
                            Spacer()
                            Text(Bundle.localizedString(forKey: "NoData", comment: "")).bold()
                        } else {
                            ForEach (filteredData) { item in
                                VStack(alignment: .leading, spacing: 16) {
                                    Divider()
                                    HStack {
                                        Text(hourFormatter.string(from: item.realDate) + " : " + Bundle.localizedString(forKey: item.exercise.titleExercise, comment: "")).font(.headline).bold()
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color.green)
                                        Text(" : " + "\(item.managedTics)")
                                    }
                                    
                                    HStack {
                                        Label(computeDuration(item.duration), systemImage: "timer")
                                        Spacer()
                                        Image(systemName: "xmark")
                                            .foregroundColor(Color.red)
                                        Text(" : " + "\(item.notManagedTics)")
                                    }
                                    
                                    Divider()
                                }
                            }
                        }
                    }
                    .padding(.bottom, 32)
                }
                .padding()
            }
            .navigationTitle(Bundle.localizedString(forKey: "Charts", comment: ""))
            .background(Color.sand.ignoresSafeArea())
            .sheet(isPresented: $isDatePickerPresented) {
                DatePickerSheet(selectedDate: $selectedDate)
            }
        }
        .overlay(
            Button(action: {
                vibrate(0)
                isDatePickerPresented.toggle()
            }) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.greenVariant)
                    .padding(.horizontal)
            }
                .padding()
                .offset(x: 15, y: 40)
                .alignmentGuide(.top) { d in d[.top] }
            , alignment: .topTrailing
        )
    }
    
    private func nearestDay(from day: Date, in data: [Date]) -> Date {
        var res = Date()
        for d in data {
            res = d
            if day >= d {
                break
            }
        }
        return res
    }
    
    private func computeDuration(_ seconds: Int) -> String {
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
