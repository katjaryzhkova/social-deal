import Foundation

struct Deal: Codable, Identifiable, Equatable {
    let unique: String
    let title: String
    let image: String
    let sold_label: String
    let company: String
    let city: String
    let prices: Prices

    var id: String { unique }

    static func == (lhs: Deal, rhs: Deal) -> Bool {
        return lhs.unique == rhs.unique
    }
}
