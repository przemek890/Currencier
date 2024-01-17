func formatNumber(_ number: Double) -> String {
    if number >= 100 {
        return "%.0f"
    } else if number >= 10 {
        return "%.1f"
    } else if number >= 1 {
        return "%.2f"
    } else {
        return "%.2f"
    }
}
