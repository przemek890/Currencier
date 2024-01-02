import Foundation
import Alamofire


func getData(currencies: [String]) {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let folderURL = directoryURL.appendingPathComponent("Exchange_rates")
    
    print("folderURL: \(folderURL.path)\n")

    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd" // Zmień format daty na 'yyyyMMdd' dla stooq.pl

    let endDateString = formatter.string(from: date) // Data końcowa to dzisiejsza data

    // Oblicz datę początkową jako datę sprzed miesiąca
    let startDate = Calendar.current.date(byAdding: .year, value: -1, to: date)!
    let startDateString = formatter.string(from: startDate)

    // Sprawdź, czy istnieją jakiekolwiek pliki CSV z dzisiejszą datą
    let files = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
    let todaysFilesExist = files?.contains { $0.lastPathComponent.hasSuffix("\(endDateString).csv") } ?? false

    if !todaysFilesExist {
        // Usuń wszystkie pliki w folderze
        for fileURL in files ?? [] {
            try? fileManager.removeItem(at: fileURL)
        }

        // Pobierz nowe pliki CSV dla każdej waluty
        let group = DispatchGroup()
        for currency in currencies {
            group.enter()
            let fileURL = folderURL.appendingPathComponent("\(currency)_\(endDateString).csv")
            let csvURL = "https://stooq.pl/q/d/l/?s=\(currency)&d1=\(startDateString)&d2=\(endDateString)&i=d"
            downloadCSV(from: csvURL, to: fileURL, completion: { group.leave() })
        }
        group.wait()
    }
}

func downloadCSV(from url: String, to destination: URL, completion: @escaping () -> Void) {
    AF.download(url, to: { _, _ -> (destinationURL: URL, options: DownloadRequest.Options) in
        return (destinationURL: destination, options: [.removePreviousFile, .createIntermediateDirectories])
    }).response { response in
        if response.error == nil, let path = response.fileURL?.path {
            print("The CSV file was successfully downloaded and saved as \(path)")
        }
        completion()
    }
}


struct DataRow {
    let currency: String
    let date: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
}


func loadCSVData(currencies: [String]) -> [DataRow] {
    var dataRows: [DataRow] = []
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let folderURL = directoryURL.appendingPathComponent("Exchange_rates")

    for currency in currencies {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                if fileURL.lastPathComponent.hasPrefix("\(currency)_"), fileURL.pathExtension == "csv" {
                    let data = try String(contentsOf: fileURL)
                    let rows = data.components(separatedBy: "\n")
                    for row in rows {
                        let cleanRow = row.replacingOccurrences(of: "\r", with: "")
                        let columns = cleanRow.components(separatedBy: ",")
                        if columns.count == 5 {
                            let dataRow = DataRow(currency: currency, date: columns[0], open: Double(columns[1]) ?? 0.0, high: Double(columns[2]) ?? 0.0, low: Double(columns[3]) ?? 0.0, close: Double(columns[4]) ?? 0.0)
                            dataRows.append(dataRow)
                        }
                    }
                }
            }
        } catch {
            print("Failed to read file: \(error)")
        }
    }
    return dataRows
}


