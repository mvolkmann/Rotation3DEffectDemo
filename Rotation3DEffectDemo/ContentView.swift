import SwiftUI

struct ContentView: View {
    @State private var backDegrees = 90.0
    @State private var frontDegrees = 0.0
    @State private var isFlipped = false

    @State private var dragAmount = CGSize.zero

    let cardHeight = 300.0
    let cardWidth = 200.0
    let duration: CGFloat = 0.3

    let frontFill = LinearGradient(
        gradient: Gradient(colors: [.red, .blue]),
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    let backFill = LinearGradient(
        gradient: Gradient(colors: [.blue, .yellow]),
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )

    var body: some View {
        ZStack {
            card(text: "Front", fill: frontFill, degrees: $frontDegrees)
            card(text: "Back", fill: backFill, degrees: $backDegrees)
        }
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
        .onTapGesture {
            print("got tap")
            flip()
        }
    }

    private func card(
        text: String,
        fill: some ShapeStyle,
        degrees: Binding<Double>
    ) -> some View {
        ZStack {
            Rectangle()
                .fill(fill)
                .frame(width: cardWidth, height: cardHeight)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            Text(text).font(.largeTitle)
        }
        .rotation3DEffect(
            Angle(degrees: degrees.wrappedValue),
            axis: (x: 0, y: 1, z: 0)
        )
    }

    private func flip() {
        isFlipped.toggle()
        if isFlipped {
            withAnimation(.linear(duration: duration)) {
                frontDegrees = -90
            }
            withAnimation(.linear(duration: duration).delay(duration)) {
                backDegrees = 0
            }
        } else {
            withAnimation(.linear(duration: duration)) {
                backDegrees = 90
            }
            withAnimation(.linear(duration: duration).delay(duration)) {
                frontDegrees = 0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
