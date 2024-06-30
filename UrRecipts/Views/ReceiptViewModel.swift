//
//  ReceiptViewModel.swift
//  UrRecipts
//
//  Created by Carlos Tipán on 26/5/24.
//

import SwiftUI
import Vision

class ReceiptViewModel: ObservableObject {
    let dateTimePattern = "\\b\\d{1,2}[/-]\\d{1,2}[/-]\\d{2,4}\\s+\\d{1,2}:\\d{2}(?:\\s*[ap]m)?\\b"
    let datePattern = "\\b\\d{1,2}[/-]\\d{1,2}[/-]\\d{2,4}\\b"
    let timePattern = "\\b\\d{1,2}:\\d{2}(?:\\s*[ap]m)?\\b"
    let phonePattern = "\\b(Telf:)?\\s?\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b"
    let emailPattern = "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"
    let addressPattern = "\\b(c\\/|calle|c\\.|avenida|av\\.|plaza|plz\\.|pza\\.|carretera|crta\\.|carrer|passeig|p\\.|passeig|psg\\.)\\b[\\s\\w\\d,-]+"

    
    @Published var receipt = Receipt()
    
    func recognizeText(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
                        
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                return
            }
            
            var date: String?
            let receipt = Receipt()
            let maximumCandidates = 1
            var maxTitleHeight: CGFloat = 0.0
            
            for observation in observations {
                guard let candidate = observation.topCandidates(maximumCandidates).first else { continue }
                let text = candidate.string
                let boundingBoxHeight = observation.boundingBox.height
                
                if boundingBoxHeight > maxTitleHeight {
                    receipt.title = text
                    maxTitleHeight = boundingBoxHeight
                }  else {
                    
                    if let dateTimeRange = text.range(of: dateTimePattern, options: .regularExpression) {
                        date = String(text[dateTimeRange])
                    }
                    
                    if let dateRange = text.range(of: datePattern, options: .regularExpression) {
                        let smallDate = String(text[dateRange])
                        date = ((date ?? "").isEmpty ? smallDate : "\(smallDate) ")                    }
                    
                    if let timeRange = text.range(of: timePattern, options: .regularExpression) {
                        let time = String(text[timeRange])
                        date = ((date ?? "").isEmpty ? time : "\(date!) \(time)")
                    }
                    
                    if let phoneMatches = text.range(of: phonePattern, options: .regularExpression) {
                        receipt.phone = String(text[phoneMatches])
                    } else if text.lowercased().starts(with: "telf") || text.lowercased().starts(with: "tel") {
                        if let match = text.range(of: "\\b\\d+\\b", options: .regularExpression) {
                            receipt.phone = String(text[match])
                        }
                    }
                    
                    if let emailMatches = text.range(of: emailPattern, options: .regularExpression) {
                        receipt.email = String(text[emailMatches])
                    }
                    
                    if let addressRange = text.lowercased().range(of: addressPattern, options: .regularExpression) {
                        receipt.address = String(text[addressRange])
                    }
                    
                    
                    receipt.fullInfo.append(text)
                }
            }
            
            receipt.date = date != nil ? parseDate(date!) ?? Date() : Date()
            
            DispatchQueue.main.async {
                self.receipt = receipt
            }
        }
        
        do {
            try handler.perform([request])
        }
        catch {
            print (error)
        }
    }
    
    func parseDate(_ dateString: String) -> Date? {
        let formats = ["dd/MM/yyyy HH:mm", "dd/MM/yy HH:mm", "dd/MM/yyyy", "HH:mm"]
        let dateFormatter = DateFormatter()
        var date: Date?

        for format in formats {
            dateFormatter.dateFormat = format
            if let parsedDate = dateFormatter.date(from: dateString) {
                date = parsedDate
                break
            }
        }

        if date == nil && dateString == "HH:mm" {
            date = Date()
        }

        return date
    }

}
