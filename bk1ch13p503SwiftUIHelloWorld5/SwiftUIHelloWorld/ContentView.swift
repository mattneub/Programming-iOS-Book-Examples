

import SwiftUI

struct ContentView : View {
    @State var isHello = true
    @EnvironmentObject var defaults : Defaults
    @Environment(\.timeZone) var timeZone // just showing the syntax
    var greeting : String {
        self.isHello ? "Hello" : "Goodbye"
    }
    @State var showSheet = false
    var body: some View {
        VStack {
            Button("Show Message") {
                self.showSheet.toggle()
                print(self.timeZone)
            }.sheet(isPresented: $showSheet) {
                Greeting(greeting: self.greeting,
                         username: self.$defaults.username)
            }
            Spacer()
            Text(self.defaults.username.isEmpty ? "" : greeting + ", " + self.defaults.username)
            Spacer()
            Toggle("Friendly", isOn: self.$isHello)
        }.frame(width: 150, height: 100)
            .padding(20)
            .background(Color.yellow)
    }
}

struct Greeting : View {
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

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
