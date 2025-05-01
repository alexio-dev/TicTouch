import SwiftUI

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .scaleEffect(1.25)
                .padding(.vertical, 20)
            
            Button ( action : {
                dismiss()
            }) {
                Text(Bundle.localizedString(forKey: "Done", comment: ""))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .frame(width: 280, height: 70)
            .background(.greenVariant)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.sand.opacity(0.65))
        .ignoresSafeArea()
        .presentationDetents([.medium])
    }
}
