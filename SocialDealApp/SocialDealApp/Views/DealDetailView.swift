import SwiftUI

struct DealDetailView: View {
    let deal: Deal
    @ObservedObject private var viewModel: DealDetailViewModel
    @AppStorage("currencyCode") private var currencyCode: String = "EUR"
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @ObservedObject private var currencyConverter = CurrencyConverter.shared

    init(deal: Deal) {
        self.deal = deal
        self.viewModel = DealDetailViewModel()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                // Use DealCard without navigation action
                DealCard(deal: viewModel.deal, onNavigate: nil)
                    .padding(.horizontal)
                    .padding(.top)

                // Description Section
                Text("Description")
                    .font(.headline)
                    .padding([.horizontal, .top])

                if let description = viewModel.dealDetail?.description.htmlToString {
                    Text(description)
                        .padding(.horizontal)
                } else {
                    ProgressView()
                        .padding()
                }
            }
        }
        .navigationBarTitle("Deal Details", displayMode: .inline)
    }
}
