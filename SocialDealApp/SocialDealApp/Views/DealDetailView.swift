import SwiftUI

struct DealDetailView: View {
    @StateObject var viewModel: DealDetailViewModel
    @AppStorage("currencyCode") var currencyCode: String = "EUR"
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    init(uniqueID: String) {
        _viewModel = StateObject(wrappedValue: DealDetailViewModel(uniqueID: uniqueID, favoritesViewModel: FavoritesViewModel()))
    }

    var body: some View {
        ScrollView {
            if let deal = viewModel.dealDetail {
                VStack(alignment: .leading) {
                    Text(deal.title)
                        .font(.title)
                        .padding(.top)
                    Text(deal.company)
                        .font(.headline)
                    Text(deal.city)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    HStack {
                        Text(deal.sold_label)
                            .font(.caption)
                        Spacer()
                        Text(deal.prices.from_price?.formatted(currencyCode: currencyCode) ?? "")
                            .strikethrough()
                            .foregroundColor(.gray)
                        Text(deal.prices.price?.formatted(currencyCode: currencyCode) ?? "")
                            .font(.headline)
                    }
                    .padding(.top, 5)
                    Divider()
                        .padding(.vertical)
                    Text("Description")
                        .font(.headline)
                    Text(deal.description.htmlToString)
                        .padding(.top, 5)
                }
                .padding(.horizontal)
            } else {
                ProgressView()
            }
        }
        .navigationBarItems(trailing: Button(action: {
            viewModel.toggleFavorite()
        }) {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(viewModel.isFavorite ? .red : .primary)
        })
        .navigationTitle("Deal Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
