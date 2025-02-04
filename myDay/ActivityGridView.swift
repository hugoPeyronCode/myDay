//
//  ActivityGridView.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI

struct ActivityGrid: View {
  @Binding var activities: [Activities]
  @Binding var draggingItem: Activities?
  @Binding var activitiesProgress: [Activities: Double]
  let columnsCount = 2


  func incrementProgress(for activity: Activities) {
      let currentProgress = activitiesProgress[activity] ?? 0
      let increment: Double

      switch activity {
      case .meditation, .tango, .abdoToning, .focus, .breathing, .doNothing:
          increment = 1.0 / Double(activity.dailyGoal) // 1 minute increment
      case .journaling:
          increment = 50.0 / Double(activity.dailyGoal) // 50 words increment
      case .pushUps:
          increment = 5.0 / Double(activity.dailyGoal) // 5 pushups increment
      }

      activitiesProgress[activity] = min(1.0, currentProgress + increment)
  }


  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: Array(repeating: GridItem(spacing: 10), count: columnsCount),
        spacing: 10
      ) {
        ForEach(activities, id: \.self) { activity in
          GeometryReader { geometry in
            ActivityCard(
              activity: activity,
              size: geometry.size,
              draggingItem: $draggingItem,
              activities: $activities,
              progress: activitiesProgress[activity] ?? 0
            )
            .onTapGesture {
              withAnimation(.spring(duration: 0.6)) {
                activitiesProgress[activity] = min(1.0, (activitiesProgress[activity] ?? 0) + 0.2)
              }
            }
            .onLongPressGesture {
              withAnimation(.spring(duration: 0.6)) {
                activitiesProgress[activity] = 0.0
              }
            }
          }
          .frame(height: UIScreen.main.bounds.height * 0.2)
        }
      }
      .padding()
    }
  }
}

struct ActivityGrid_Previews: View {
  @State private var activities: [Activities] = [.meditation, .breathing, .focus]
  @State private var draggingItem: Activities?
  @State private var progress: [Activities: Double] = [
    .meditation: 0.3,
    .breathing: 0.7,
    .focus: 1.0
  ]

  var body: some View {
    ActivityGrid(
      activities: $activities,
      draggingItem: $draggingItem,
      activitiesProgress: $progress
    )
  }
}

#Preview {
  ActivityGrid_Previews()
}
