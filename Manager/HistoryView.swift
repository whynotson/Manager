//
//  HistoryView.swift
//  HistoryView
//
//  Created by Quach Son on 09/08/2025.
//
import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var viewModel: ManagerViewModel
    @State private var showShareSheet = false
    @State private var exportURL: URL?

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Lịch sử nhập hàng")) {
                    ForEach(viewModel.importHistory) { record in
                        VStack(alignment: .leading) {
                            Text("Số lượng: \(record.quantity)")
                            Text("Đơn giá: \(record.pricePerUnit)")
                            Text("Thời gian nhập: \(formattedDate(record.timestamp))")
                        }
                    }
                    .onDelete(perform: viewModel.deleteImport)
                }

                Section(header: Text("Lịch sử xuất hàng")) {
                    ForEach(viewModel.exportHistory) { record in
                        VStack(alignment: .leading) {
                            Text("Tên: \(record.name)")
                            Text("Số điện thoại: \(record.phone)")
                            Text("Địa chỉ: \(record.address)")
                            Text("Số lượng: \(record.quantity)")
                            Text("Tổng tiền: \(record.totalPrice)")
                            Text("Thời gian xuất: \(formattedDate(record.timestamp))")
                        }
                    }
                    .onDelete(perform: viewModel.deleteExport)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Lịch sử")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Xuất file") {
                        if let url = viewModel.exportToFile() {
                            exportURL = url
                            showShareSheet = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showShareSheet, content: {
                if let url = exportURL {
                    ShareSheet(activityItems: [url])
                }
            })
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
