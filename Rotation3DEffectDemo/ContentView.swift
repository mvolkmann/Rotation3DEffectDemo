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

    /*
     @State private var dragAmount = CGSize.zero

         .gesture(
             DragGesture()
                 .onChanged {
                     let size = $0.translation // type is CGSize
                     print("size: \(size)")
                     var degrees = abs(size.width) / 2.0
                     if !isFlipped { degrees *= -1 }
                     print("isFlipped: \(isFlipped), degrees: \(degrees)")
                     frontDegrees = max(min(degrees, 0), -90)
                     backDegrees = max(min(90 - degrees, 90), 0)
                     print("front: \(frontDegrees), back \(backDegrees)")
                 }
                 .onEnded { _ in
                     withAnimation(.spring()) {
                         dragAmount = .zero
                     }
                 }
         )
     */
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
