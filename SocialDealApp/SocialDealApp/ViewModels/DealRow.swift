import SwiftUI

struct DealRow: View {
    let deal: Deal
    @AppStorage("currencyCode") var currencyCode: String = "EUR"
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // Image loading...
            if !deal.image.isEmpty {
                // Load image
            } else {
                // Placeholder
            }

            Text(deal.title)
                .font(.headline)
                .padding(.top, 5)
            Text(deal.company)
                .font(.subheadline)
            Text(deal.city)
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Text(deal.sold_label)  
                    .font(.caption)
                Spacer()
                if let fromPrice = deal.prices.from_price?.formatted(currencyCode: currencyCode) {
                    Text(fromPrice)
                        .strikethrough()
                        .foregroundColor(.gray)
                }
                if let price = deal.prices.price?.formatted(currencyCode: currencyCode) {
                    Text(price)
                        .font(.headline)
                } else {
                    Text("No Price")
                        .font(.headline)
                }
            }
            .padding(.top, 5)
        }
        .padding(.vertical)
    }
}
