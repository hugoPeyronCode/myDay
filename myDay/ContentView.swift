//
//  ContentView.swift
//  myDay
//
//  Created by Hugo Peyron on 03/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var activities: [Activities] = [
        .meditation,
        .journaling,
        .tango,
        .pushUps,
        .abdoToning,
        .breathing,
        .focus
    ]
    @State private var draggingItem: Activities?
    @State private var activitiesProgress: [Activities: Double] = [:]

    var body: some View {
        NavigationStack {
            ActivityGrid(
                activities: $activities,
                draggingItem: $draggingItem,
                activitiesProgress: $activitiesProgress
            )
            .navigationTitle("24:10:36")
        }
        .onAppear {
            for activity in activities {
                if activitiesProgress[activity] == nil {
                    activitiesProgress[activity] = 0.0
                }
            }
        }
    }
}

struct DragPreview: View {
  let size: CGSize

  var body: some View {
    RoundedRectangle(cornerRadius: 25)
      .fill(.ultraThinMaterial)
      .frame(width: size.width, height: size.height)
  }
}

#Preview {
    ContentView()
}
