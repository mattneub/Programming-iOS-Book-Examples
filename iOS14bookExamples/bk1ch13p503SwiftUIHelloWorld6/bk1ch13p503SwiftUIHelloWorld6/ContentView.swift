

import SwiftUI
import Combine

class NameSaver : ObservableObject {
    @Published var username: String = ""
    var storage = Set<AnyCancellable>()
    var fileURL : URL? {
        let fm = FileManager.default
        if let docs = try? fm.url(for: .documentDirectory, in: .userDomainMask,
                                  appropriateFor: nil, create: true) {
            return docs.appendingPathComponent("username.txt")
        }
        return nil
    }
    init() {
        self.username = self.read() ?? ""
        self.$username
            .debounce(for: 0.4, scheduler: DispatchQueue.main)
            .sink { self.save($0) }
            .store(in: &self.storage)
    }
    func read() -> String? {
        print("reading name")
        if let url = self.fileURL {
            return try? String(contentsOf: url, encoding: .utf8)
        }
        return nil
    }
    func save(_ newName: String) {
        print("writing new name", newName) // showing that debounce is working
        if let url = self.fileURL {
            try? newName.write(to: url, atomically: true, encoding: .utf8)
        }
    }
    deinit {
        print("farewell from NameSaver")
    }
}

struct ContentView : View {
    init() {
        print("init ContentView")
    }
    @State var isHello = true
    @StateObject var nameSaver = NameSaver()
    var greeting : String {
        self.isHello ? "Hello" : "Goodbye"
    }
    @State var showSheet = false
    var body: some View {
        print("new ContentView body"); return
            VStack {
                Button("Show Message") {
                    self.showSheet.toggle()
                }.sheet(isPresented: $showSheet) {
                    Greeting(greeting: self.greeting,
                             username: self.$nameSaver.username)
                }
                Spacer()
                Text(self.nameSaver.username.isEmpty ? "" : greeting + ", " + self.nameSaver.username)
                Spacer()
                Toggle("Friendly", isOn: self.$isHello)
            }.frame(width: 150, height: 100)
            .padding(20)
            .background(Color.yellow)
    }
}

struct Greeting : View {
    init(greeting: String, username: Binding<String>) {
        self.greeting = greeting
        self._username = username
        print("init Greeting") // proving that the whole struct is recreated each time dependency changes
    }
    let greeting : String
    @Binding var username : String
    var body: some View {
        VStack {
            Text(greeting + ", " + username)
            TextField("Your Name", text:$username)
                .frame(width:200)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }.padding(20)
        .background(Color.green)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
