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

    @State private var currentlyFlipped = false
    @State private var initiallyFlipped: Bool?

    let cardHeight = 400.0
    // A standard playing card is 2.5" wide and 3.5" tall.
    var cardWidth: Double { cardHeight * 2.5 / 3.5 }
    let cornerRadius = 20.0
    let duration: CGFloat = 0.3

    typealias Axis = (x: CGFloat, y: CGFloat, z: CGFloat)
    let axis: Axis = (x: 0, y: 1, z: 0)

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
        .gesture(
            DragGesture()
                .onChanged {
                    if initiallyFlipped ==
                        nil { initiallyFlipped = currentlyFlipped }

                    let x = $0.location.x
                    guard x >= 0, x <= cardWidth else { return }

                    let startX = $0.startLocation.x
                    let swipingLeft = startX > cardWidth / 2

                    let fullDistance = (startX - cardWidth / 2) * 2
                    let percent = (startX - x) / fullDistance
                    let boundedPercent = max(min(percent, 1), 0)
                    let deltaDegrees = boundedPercent * 90 * 2

                    if currentlyFlipped {
                        if swipingLeft {
                            frontDegrees = -90
                            if let initiallyFlipped, initiallyFlipped {
                                backDegrees = -deltaDegrees
                            } else {
                                backDegrees = 180 - deltaDegrees
                            }
                            if backDegrees < -90 { currentlyFlipped = false }
                        } else {
                            frontDegrees = 90
                            if let initiallyFlipped, initiallyFlipped {
                                backDegrees = deltaDegrees
                            } else {
                                backDegrees = deltaDegrees - 180
                            }
                            if backDegrees > 90 { currentlyFlipped = false }
                        }
                    } else {
                        if swipingLeft {
                            backDegrees = -90
                            if let initiallyFlipped, initiallyFlipped {
                                frontDegrees = 180 - deltaDegrees
                            } else {
                                frontDegrees = -deltaDegrees
                            }
                            if frontDegrees < -90 { currentlyFlipped = true }
                        } else {
                            backDegrees = 90
                            if let initiallyFlipped, initiallyFlipped {
                                frontDegrees = deltaDegrees - 180
                            } else {
                                frontDegrees = deltaDegrees
                            }
                            if frontDegrees > 90 { currentlyFlipped = true }
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        if currentlyFlipped {
                            backDegrees = 0
                        } else {
                            frontDegrees = 0
                        }
                        initiallyFlipped = nil // unset
                    }
                }
        )
    }

    private func flip() {
        currentlyFlipped.toggle()
        if currentlyFlipped {
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
