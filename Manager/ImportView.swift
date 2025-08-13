//
//  ImportView.swift
//  ImportView
//
//  Created by Quach Son on 07/08/2025.
//

import SwiftUI

struct ImportView: View {
    @State private var quantity = ""
    @State private var price = ""
    @State private var showAlert = false
    @EnvironmentObject var viewModel: ManagerViewModel

    private var formattedStock: String {
        "Số lượng hiện tại trong kho: \(viewModel.stock)"
    }

    private var formattedPrice: String {
        if let number = Int(price) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            return (formatter.string(from: NSNumber(value: number)) ?? "0") + "đ"
        }
        return ""
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Nhập")
                        .font(.largeTitle)
                        .bold()
                    Text(formattedStock)
                        .font(.body)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Số lượng thùng")
                        .font(.headline)
                    TextField("Nhập số lượng thùng", text: $quantity)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Text("Giá nhập mỗi thùng (VNĐ)")
                        .font(.headline)
                    TextField("Nhập giá mỗi thùng", text: $price)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    if !formattedPrice.isEmpty {
                        Text("Giá định dạng: \(formattedPrice)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                Button(action: {
                    if let q = Int(quantity), let p = Int(price) {
                        viewModel.importGoods(quantity: q, pricePerUnit: p)
                        quantity = ""
                        price = ""
                        showAlert = true
                    }
                }) {
                    Text("Nhập kho")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Thành công"), message: Text("Đã nhập hàng thành công"), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .padding(.top, 40)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
    }
}
