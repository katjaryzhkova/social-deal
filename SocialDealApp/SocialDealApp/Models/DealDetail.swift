import Foundation

struct DealDetail: Codable {
    let unique: String
    let title: String
    let company: String
    let description: String
    let city: String
    let sold_label: String
    let prices: Prices
}
