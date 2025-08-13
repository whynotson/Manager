import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ImportView().tabItem {
                Label("Nhập kho", systemImage: "tray.and.arrow.down")
            }
            ExportView().tabItem {
                Label("Xuất kho", systemImage: "tray.and.arrow.up")
            }
            HistoryView().tabItem {
                Label("Lịch sử", systemImage: "clock")
            }
        }
    }
}
