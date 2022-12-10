import SwiftUI

// This requires four ViewBuilder arguments.
// Since each can return a different kind of View,
// we need four generic parameters to represent their types.
struct Card<V1, V2, V3, V4>: View
    where V1: View, V2: View, V3: View, V4: View {
    @ViewBuilder let frontBg: V1
    @ViewBuilder let frontFg: V2
    @ViewBuilder let backBg: V3
    @ViewBuilder let backFg: V4

    // backDegrees is always 90 more than frontDegrees.
    @State private var backDegrees = 90.0 // goes from 90 to 0
    @State private var frontDegrees = 0.0 // goes from 0 to -90

    @State private var dragAmount = CGSize.zero
    @State private var isFlipped = false

    typealias Axis = (x: CGFloat, y: CGFloat, z: CGFloat)

    let axis: Axis = (x: 0, y: 1, z: 0)
    let cardHeight = 300.0
    let cardWidth = 200.0
    let cornerRadius = 20.0
    let duration: CGFloat = 0.3

    var body: some View {
        ZStack {
            ZStack {
                frontBg
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                frontFg
            }
            .rotation3DEffect(
                Angle(degrees: frontDegrees),
                axis: axis
            )
            ZStack {
                backBg
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                backFg
            }
            .rotation3DEffect(
                Angle(degrees: backDegrees),
                axis: axis
            )
        }
        .onTapGesture {
            flip()
        }
        /*
         .gesture(
             DragGesture()
                 .onChanged {
                     let size = $0.translation // type is CGSize
                     // TODO: Base the percentage on distance from horizontal center of card.
                     // TODO: Treat left and right drags differently.
                     let percent = -size.width / 80
                     let bounded = max(min(percent, 1), 0)
                     isFlipped = frontDegrees <= -90
                     let delta = percent * 90
                     if isFlipped {
                         frontDegrees = -90
                         backDegrees = delta
                     } else {
                         backDegrees = 90
                         frontDegrees = -delta
                     }
                 }
                 .onEnded { _ in
                     withAnimation(.spring()) {
                         dragAmount = .zero
                     }
                 }
         )
         */
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
