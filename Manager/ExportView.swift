//
//  ExportView.swift
//  ExportView
//
//  Created by Quach Son on 07/08/2025.
//
import SwiftUI

struct ExportView: View {
    @State private var name = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var quantity = ""
    @State private var price = ""
    @State private var alertTitle = ""
    @State private var alertMessage = ""
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
                    Text("Xuất")
                        .font(.largeTitle)
                        .bold()
                    Text(formattedStock)
                        .font(.body)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        Text("Tên khách hàng")
                            .font(.headline)
                        TextField("Nhập tên", text: $name)
                        Text("Số điện thoại")
                            .font(.headline)
                        TextField("Nhập số điện thoại", text: $phone)
                        Text("Địa chỉ")
                            .font(.headline)
                        TextField("Nhập địa chỉ", text: $address)
                    }

                    Group {
                        Text("Số lượng thùng")
                            .font(.headline)
                        TextField("Nhập số lượng", text: $quantity)
                            .keyboardType(.numberPad)

                        Text("Giá xuất mỗi thùng (VNĐ)")
                            .font(.headline)
                        TextField("Nhập giá xuất", text: $price)
                            .keyboardType(.numberPad)

                        if !formattedPrice.isEmpty {
                            Text("Giá định dạng: \(formattedPrice)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

                Button(action: {
                    guard let q = Int(quantity), let p = Int(price) else {
                        alertTitle = "Lỗi"
                        alertMessage = "Vui lòng nhập số hợp lệ"
                        showAlert = true
                        return
                    }

                    if viewModel.exportGoods(customerName: name, phone: phone, address: address, quantity: q, pricePerUnit: p) {
                        name = ""
                        phone = ""
                        address = ""
                        quantity = ""
                        price = ""
                        alertTitle = "Thành công"
                        alertMessage = "Đã xuất hàng thành công"
                        showAlert = true
                    } else {
                        alertTitle = "Lỗi"
                        alertMessage = "Không đủ hàng trong kho"
                        showAlert = true
                    }
                }) {
                    Text("Xuất kho")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .padding(.top, 40)
            .frame(maxWidth: .infinity)
        }
        .hideKeyboardOnTap()
    }
}
