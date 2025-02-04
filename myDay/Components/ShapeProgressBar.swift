//
//  ShapeProgressBar.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI

struct ShapeProgressBar<S: Shape>: View {
  let progress: Double
  let backgroundColor: Color
  let color: Color
  let lineWidth: CGFloat
  let shape: S

  init(
    shape: S,
    progress: Double,
    backgroundColor: Color = .gray.opacity(0.2),
    color: Color = .blue,
    lineWidth: CGFloat = 10
  ) {
    self.shape = shape
    self.progress = progress
    self.backgroundColor = backgroundColor
    self.color = color
    self.lineWidth = lineWidth
  }

  var body: some View {
    ZStack {
      // Background shape
      shape
        .stroke(
          backgroundColor,
          lineWidth: lineWidth
        )

      // Progress shape
      shape
        .trim(from: 0, to: progress)
        .stroke(
          color,
          style: StrokeStyle(
            lineWidth: lineWidth,
            lineCap: .round
          )
        )
    }
  }
}

#Preview {
  ShapeProgressBar(shape: .rect(cornerRadius: 25), progress: 0.6)
    .padding()
}

