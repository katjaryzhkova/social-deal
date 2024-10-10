import Foundation

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
                do {
                    let response = try JSONDecoder().decode(DealListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.deals = response.deals
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            } else {
                print("Error: Data is nil")
            }
        }.resume()
    }
}
