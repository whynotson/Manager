//
//  ImportRecord.swift
//  Manager
//
//  Created by Quach Son on 08/08/2025.
//

import Foundation

struct ExportRecord: Identifiable, Codable {
    var id = UUID()
    let quantity: Int
    let pricePerUnit: Int
    let timestamp: Date
}
