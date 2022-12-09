import SwiftUI

struct ContentView: View {
    var body: some View {
        Card(
            frontBg: {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.red, .blue]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ))
            },
            frontFg: {
                Text("Front").font(.largeTitle)
            },
            backBg: {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.blue, .yellow]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    ))
            },
            backFg: {
                Text("Back").font(.largeTitle)
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
