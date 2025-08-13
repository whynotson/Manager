import SwiftUI

@main
struct ManagerApp: App {
    @StateObject private var viewModel = ManagerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
