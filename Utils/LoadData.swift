import Foundation

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
