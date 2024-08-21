import Foundation
import Alamofire
//----------------------------------------------------

func getData(currencies: [String]) {
    let fileManager = FileManager.default
    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let folderURL = directoryURL.appendingPathComponent("Exchange_rates")
    
    print("folderURL: \(folderURL.path)\n")

    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    let endDateString = formatter.string(from: date)

    let startDate = Calendar.current.date(byAdding: .year, value: -1, to: date)!
    let startDateString = formatter.string(from: startDate)

    let files = try? fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
    let todaysFilesExist = files?.contains { $0.lastPathComponent.hasSuffix("\(endDateString).csv") } ?? false

    if !todaysFilesExist {
        for fileURL in files ?? [] {
            try? fileManager.removeItem(at: fileURL)
        }

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
