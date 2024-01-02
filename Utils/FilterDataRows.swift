import Foundation
//----------------------------------------------------

func filterDataRows(_ dataRows: [DataRow], range: Int) -> [DataRow] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    let calendar = Calendar.current
    let startDate = calendar.date(byAdding: .day, value: -range, to: Date())!

    return dataRows.filter { dataRow in
        if let date = dateFormatter.date(from: dataRow.date) {
            return date >= startDate
        } else {
            return false
        }
    }
}
