

import SwiftUI

struct ContentView : View {
    @State var isHello = true
    var greeting : String {
        self.isHello ? "Hello" : "Goodbye"
    }
    @State var showSheet = false
    var body: some View {
        VStack {
            Button("Show Message") {
                self.showSheet.toggle()
            }.sheet(isPresented: $showSheet) {
                Greeting(greeting: self.greeting)
                // Greeting2(greeting:self.greeting,
                //          isPresented:self.$showSheet)
            }
            Spacer()
            Toggle("Friendly", isOn: $isHello)
        }.frame(width: 150, height: 100)
            .padding(20)
            .background(Color.yellow)
    }
}

struct Greeting : View {
    let greeting : String
    var body: some View {
        Text(greeting + " World")
    }
}

// not in book
// how to give a presented view a Done button

struct Greeting2 : View {
    let greeting : String
    @Binding var isPresented : Bool
    var body: some View {
        VStack {
            Text(greeting + " World")
            Spacer().frame(height:30)
            // Button("Done", action: {self.modal?.value = false})
            // hmm, that doesn't seem to work any more
            // let's pass a binding instead
            Button("Done", action: {self.isPresented = false})
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
