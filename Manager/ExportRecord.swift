import Foundation

struct ExportRecord: Identifiable, Codable {
    var id = UUID()
    let name: String
    let phone: String
    let address: String
    let quantity: Int
    let totalPrice: Int
    let timestamp: Date
}
