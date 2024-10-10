import Foundation
import Combine
import UIKit

class CurrencyConverter: ObservableObject {
    static let shared = CurrencyConverter()
    private init() {
        loadExchangeRate()
        observeAppLifecycle()
    }

    @Published var exchangeRate: Double? // EUR to USD rate
    @Published var lastUpdated: Date?
    @Published var errorMessage: String?

    private let exchangeRateKey = "cachedExchangeRate"
    private let lastUpdatedKey = "exchangeRateLastUpdated"
    private let exchangeRateExpiration: TimeInterval = 3600 // 1 hour in seconds
    private var cancellables = Set<AnyCancellable>()

    /// Fetches the latest exchange rate from the ExchangeRate-API.
    func fetchExchangeRate() {
        let apiKey = "838602d44d1467dfd56b7db1" // using a personal account on ExchangeRate-API with a free tier (max 1500 requests/month)
        let urlString = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/EUR"

        guard let url = URL(string: urlString) else {
            print("Invalid ExchangeRate-API URL.")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Double in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }

                let decoder = JSONDecoder()
                let rateResponse = try decoder.decode(ExchangeRateResponse.self, from: data)
                guard let usdRate = rateResponse.conversion_rates["USD"] else {
                    throw URLError(.cannotDecodeContentData)
                }
                return usdRate
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch exchange rate: \(error.localizedDescription)")
                    self?.errorMessage = "Failed to fetch exchange rate. Please try again later."
                    self?.exchangeRate = nil // Disable USD conversion
                case .finished:
                    break
                }
            } receiveValue: { [weak self] rate in
                self?.exchangeRate = rate
                self?.lastUpdated = Date()
                self?.saveExchangeRate()
                print("Fetched exchange rate: 1 EUR = \(rate) USD")
            }
            .store(in: &cancellables)
    }

    /// Saves the exchange rate and last updated date to UserDefaults.
    private func saveExchangeRate() {
        if let exchangeRate = exchangeRate, let lastUpdated = lastUpdated {
            UserDefaults.standard.set(exchangeRate, forKey: exchangeRateKey)
            UserDefaults.standard.set(lastUpdated, forKey: lastUpdatedKey)
        }
    }

    /// Loads the exchange rate from UserDefaults, fetching a new rate if expired.
    private func loadExchangeRate() {
        if let storedRate = UserDefaults.standard.value(forKey: exchangeRateKey) as? Double,
           let storedDate = UserDefaults.standard.value(forKey: lastUpdatedKey) as? Date {
            let timeInterval = Date().timeIntervalSince(storedDate)
            if timeInterval < exchangeRateExpiration {
                // Use cached exchange rate
                exchangeRate = storedRate
                lastUpdated = storedDate
                print("Loaded cached exchange rate: 1 EUR = \(storedRate) USD")
            } else {
                // Cache expired, fetch new rate
                fetchExchangeRate()
            }
        } else {
            // No cached rate, fetch new rate
            fetchExchangeRate()
        }
    }

    /// Observes app lifecycle to refresh exchange rate when the app becomes active.
    private func observeAppLifecycle() {
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                self?.refreshExchangeRateIfNeeded()
            }
            .store(in: &cancellables)
    }

    /// Refreshes the exchange rate if the cached rate has expired.
    private func refreshExchangeRateIfNeeded() {
        if let lastUpdated = lastUpdated {
            let timeInterval = Date().timeIntervalSince(lastUpdated)
            if timeInterval >= exchangeRateExpiration {
                fetchExchangeRate()
            }
        } else {
            fetchExchangeRate()
        }
    }
}

struct ExchangeRateResponse: Codable {
    let conversion_rates: [String: Double]
}
