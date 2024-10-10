import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        let data = Data(self.utf8) 
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        } catch {
            print("Error converting HTML to AttributedString: \(error)")
            return nil
        }
    }

    var htmlToString: String {
        htmlToAttributedString?.string ?? ""
    }
}
