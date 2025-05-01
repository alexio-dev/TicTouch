import Foundation

class TicCache {
    static let shared = TicCache()
    private init() {}
    
    private let fileManager = FileManager.default
    private let directory = FileManager.default.temporaryDirectory
    
    func saveData(_ data: [TicData], filename: String) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(data)
            let fileURL = directory.appendingPathComponent(filename)
            try jsonData.write(to: fileURL, options: .atomic)
        } catch {
            print("Saving error: \(error)")
        }
    }
    
    func loadData(filename: String) -> [TicData]? {
        let fileURL = directory.appendingPathComponent(filename)
        
        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([TicData].self, from: jsonData)
        } catch {
            print("Loading error: \(error)")
            return nil
        }
    }
}

