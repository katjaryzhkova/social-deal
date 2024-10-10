import Foundation

class DealDetailViewModel: ObservableObject {
    @Published var dealDetail: DealDetail?

    // The deal is always loaded from the static JSON data
    @Published var deal: Deal = {
        return Deal(
            unique: "x6ji36jvyi4mj9fk",
            title: "Bioscoopticket + popcorn + drankje bij Corendon Cinema",
            image: "/deal/corendon-village-hotel-amsterdam-22113009143271.jpg",
            sold_label: "Verkocht: 19",
            company: "Corendon Village Hotel Amsterdam",
            city: "Badhoevedorp (7 km)",
            prices: Prices(
                price: Amount(amount: 1250, currency: Currency(symbol: "€", code: "EUR")),
                from_price: Amount(amount: 1700, currency: Currency(symbol: "€", code: "EUR"))
            )
        )
    }()

    init() {
        fetchDealDetail()
    }

    func fetchDealDetail() {
        // Always load from the static endpoint
        guard let url = URL(string: "https://media.socialdeal.nl/demo/details.json?id=96195509eixeq79c5c41e3q") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let dealDetail = try JSONDecoder().decode(DealDetail.self, from: data)
                    DispatchQueue.main.async {
                        self.dealDetail = dealDetail
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
