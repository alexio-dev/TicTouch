enum Tab: String, CaseIterable, Identifiable {
    var id: String {
        rawValue
    }
    
    var icon: String {
        switch self {
        case .main:
            return "person"
        case .data:
            return "chart.pie"
        case .profile:
            return "gearshape"
        }
    }
    
    var title: String {
        switch self {
        case .main:
            return "Main"
        case .data:
            return "Data"
        case .profile:
            return "Settings"
        }
    }
    
    case data
    case main
    case profile
}
