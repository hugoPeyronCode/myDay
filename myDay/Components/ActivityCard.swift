//
//  ActivityCard.swift
//  myDay
//
//  Created by Hugo Peyron on 03/02/2025.
//

import SwiftUI


struct DraggableCard: View {
  let id: Int
  @Binding var positions: [Int: CGPoint]
  @State private var offset: CGSize = .zero
  @State private var isDragging = false

  var body: some View {
    let longPressGesture = LongPressGesture(minimumDuration: 0.5)
      .onEnded { _ in
        withAnimation {
          isDragging = true
        }
      }

    let dragGesture = DragGesture()
      .onChanged { value in
        offset = value.translation
        checkForSwap(at: CGPoint(x: value.location.x, y: value.location.y))
      }
      .onEnded { _ in
        withAnimation {
          offset = .zero
          isDragging = false
        }
      }

    RoundedRectangle(cornerRadius: 25)
      .fill(.blue)
      .frame(width: 150, height: 150)
      .position(positions[id] ?? .zero)
      .offset(offset)
      .scaleEffect(isDragging ? 1.1 : 1.0)
      .gesture(longPressGesture.sequenced(before: dragGesture))
  }

  private func checkForSwap(at point: CGPoint) {
    for (otherID, otherPosition) in positions where otherID != id {
      let distance = sqrt(pow(point.x - otherPosition.x, 2) + pow(point.y - otherPosition.y, 2))
      if distance < 75 { // Swap threshold
        withAnimation {
          let currentPosition = positions[id]!
          positions[id] = otherPosition
          positions[otherID] = currentPosition
        }
      }
    }
  }
}
