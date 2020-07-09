

import SwiftUI

@main
struct MyApp: App {
    @StateObject private var defaults = Defaults()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(defaults)
        }
    }
}

class Defaults : ObservableObject {
    var username : String {
        get {
            UserDefaults.standard.string(forKey: "name") ?? ""
        }
        set {
            self.objectWillChange.send()
            UserDefaults.standard.set(newValue, forKey: "name")
        }
    }
}

