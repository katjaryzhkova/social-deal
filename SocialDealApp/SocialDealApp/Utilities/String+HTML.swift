import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        } catch {
            print("Error converting HTML to Attributed String: \(error.localizedDescription)")
            return nil
        }
    }
    
    var htmlToString: String {
        htmlToAttributedString?.string ?? ""
    }
}
