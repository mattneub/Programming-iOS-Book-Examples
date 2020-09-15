

import SwiftUI

struct ContentView : View {
    @State var isHello = true
    var greeting : String {
        self.isHello ? "Hello" : "Goodbye"
    }
    var body: some View {
        HStack {
            Text(self.greeting + " World")
            Spacer()
            Button("Tap Me") {
                self.isHello.toggle()
            }
        }.frame(width: 200)
            .padding(20)
            .background(Color.yellow)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
