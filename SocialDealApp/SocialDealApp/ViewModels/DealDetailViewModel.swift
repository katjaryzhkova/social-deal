import Foundation
import SwiftUI

class DealDetailViewModel: ObservableObject {
    @Published var dealDetail: DealDetail?
    @Published var isFavorite: Bool = false
    
    let uniqueID: String
    @ObservedObject var favoritesViewModel: FavoritesViewModel
    
    init(uniqueID: String, favoritesViewModel: FavoritesViewModel) {
        self.uniqueID = uniqueID
        self.favoritesViewModel = favoritesViewModel
        fetchDealDetail()
    }
    
    func fetchDealDetail() {
        guard let url = URL(string:"https://media.socialdeal.nl/demo/details.json?id=\(uniqueID)") else { return }
        
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
                        self.checkIfFavorite()
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func toggleFavorite() {
        guard let deal = convertDetailToDeal() else { return }
        if isFavorite {
            favoritesViewModel.removeFavorite(deal: deal)
            isFavorite = false
        } else {
            favoritesViewModel.addFavorite(deal: deal)
            isFavorite = true
        }
    }
    
    func checkIfFavorite() {
        guard let deal = convertDetailToDeal() else { return }
        isFavorite = favoritesViewModel.isFavorite(deal: deal)
    }
    
    func convertDetailToDeal() -> Deal? {
        guard let detail = dealDetail else { return nil }
        return Deal(
            unique: detail.unique,
            title: detail.title,
            image: "", 
            sold_label: detail.sold_label,
            company: detail.company,
            city: detail.city,
            prices: detail.prices
        )
    }
}
