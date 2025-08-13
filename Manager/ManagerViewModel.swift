//
//  ManagerViewModel.swift
//  ManagerViewModel
//
//  Created by Quach Son on 07/08/2025.
//

import Foundation

struct ImportRecord: Identifiable, Codable {
    var id = UUID()
    let quantity: Int
    let pricePerUnit: Int
    let timestamp: Date
}

class ManagerViewModel: ObservableObject {
    @Published var stock: Int = UserDefaults.standard.integer(forKey: "stock") {
        didSet {
            UserDefaults.standard.set(stock, forKey: "stock")
        }
    }

    @Published var exportHistory: [ExportRecord] = [] {
        didSet {
            saveExportHistory()
        }
    }

    @Published var importHistory: [ImportRecord] = [] {
        didSet {
            saveImportHistory()
        }
    }

    init() {
        loadExportHistory()
        loadImportHistory()
    }

    func importGoods(quantity: Int, pricePerUnit: Int) {
        stock += quantity
        let record = ImportRecord(quantity: quantity, pricePerUnit: pricePerUnit, timestamp: Date())
        importHistory.append(record)
    }

    func exportGoods(customerName: String, phone: String, address: String, quantity: Int, pricePerUnit: Int) -> Bool {
        guard quantity <= stock else { return false }
        stock -= quantity
        let total = quantity * pricePerUnit
        let record = ExportRecord(name: customerName, phone: phone, address: address, quantity: quantity, totalPrice: total, timestamp: Date())
        exportHistory.append(record)
        return true
    }

    func deleteExport(at offsets: IndexSet) {
        exportHistory.remove(atOffsets: offsets)
    }

    func deleteImport(at offsets: IndexSet) {
        importHistory.remove(atOffsets: offsets)
    }

    func exportToFile() -> URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let filename = "file_\(formatter.string(from: Date())).txt"
        let content = exportHistory.map { rec in
            return "\(rec.name), \(rec.phone), \(rec.address), \(rec.quantity), \(rec.totalPrice), \(rec.timestamp)"
        }.joined(separator: "\n")

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            try? content.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        }
        return nil
    }

    // MARK: - Persistence

    private func saveImportHistory() {
        if let data = try? JSONEncoder().encode(importHistory) {
            UserDefaults.standard.set(data, forKey: "importHistory")
        }
    }

    private func saveExportHistory() {
        if let data = try? JSONEncoder().encode(exportHistory) {
            UserDefaults.standard.set(data, forKey: "exportHistory")
        }
    }

    private func loadImportHistory() {
        if let data = UserDefaults.standard.data(forKey: "importHistory"),
           let decoded = try? JSONDecoder().decode([ImportRecord].self, from: data) {
            importHistory = decoded
        }
    }

    private func loadExportHistory() {
        if let data = UserDefaults.standard.data(forKey: "exportHistory"),
           let decoded = try? JSONDecoder().decode([ExportRecord].self, from: data) {
            exportHistory = decoded
        }
    }
}
