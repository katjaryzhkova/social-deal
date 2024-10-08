import Foundation
import SwiftUI

class DealsViewModel: ObservableObject {
    @Published var deals: [Deal] = []
    
    func fetchDeals() {
        guard let url = URL(string: "https://media.socialdeal.nl/demo/deals.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                // For debugging: print the received JSON as a string
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON: \(jsonString)")
                }
                
                do {
                    let response = try JSONDecoder().decode(DealListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.deals = response.deals
                    }
                } catch let DecodingError.dataCorrupted(context) {
                    print("Data corrupted:", context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("CodingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("CodingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context) {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("CodingPath:", context.codingPath)
                } catch {
                    print("Decoding error:", error.localizedDescription)
                }
            } else {
                print("Error: Data is nil")
            }
        }.resume()
    }
}
