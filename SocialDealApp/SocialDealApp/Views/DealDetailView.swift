import SwiftUI

struct DealDetailView: View {
    @ObservedObject var viewModel = DealDetailViewModel()
    @AppStorage("currencyCode") var currencyCode: String = "EUR"
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    if let imagePath = viewModel.deal.image, !imagePath.isEmpty {
                        AsyncImage(url: URL(string: "https://images.socialdeal.nl\(imagePath)")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(8)
                            } else if phase.error != nil {
                                Color.red
                                    .cornerRadius(8)
                            } else {
                                ProgressView()
                                    .frame(height: 200)
                            }
                        }
                        .frame(height: 200)
                        .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(8)
                    }

                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: favoritesViewModel.isFavorite(deal: viewModel.deal) ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    .padding(8)
                }

                // Deal information
                VStack(alignment: .leading, spacing: 4) {
                    // Deal title
                    Text(viewModel.deal.title ?? "No Title")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .padding(.bottom, 4)

                    // Company name
                    Text(viewModel.deal.company ?? "No Company")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)

                    // Location
                    Text(viewModel.deal.city ?? "No City")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)

                    // Sold label and pricing
                    HStack {
                        Text(viewModel.deal.sold_label ?? "")
                            .font(.subheadline)
                            .foregroundColor(Color.blue) 
                        Spacer()
                        // Pricing
                        if let fromPrice = viewModel.deal.prices?.from_price?.formatted(currencyCode: currencyCode) {
                            Text(fromPrice)
                                .strikethrough()
                                .foregroundColor(.gray)
                        }
                        if let price = viewModel.deal.prices?.price?.formatted(currencyCode: currencyCode) {
                            Text(price)
                                .font(.title3)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding([.horizontal, .bottom])

                Divider()
                    .padding(.vertical)
                Text("Description")
                    .font(.headline)
                    .padding(.horizontal)
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

    func toggleFavorite() {
        if favoritesViewModel.isFavorite(deal: viewModel.deal) {
            favoritesViewModel.removeFavorite(deal: viewModel.deal)
        } else {
            favoritesViewModel.addFavorite(deal: viewModel.deal)
        }
    }
}
