//
//  ActivityCard.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI

struct ActivityCard: View {
  @EnvironmentObject var streakManager: StreakManager

  let activity: Activities
  let size: CGSize

  @Binding var draggingItem: Activities?
  @Binding var activities: [Activities]
  let progress: Double

  var streakText: String {
    let streak = streakManager.activityStreaks[activity]?.currentStreak ?? 0
    return "🔥 \(streak)"
  }

  var progressColor: Color {
    switch progress {
    case 0:
      return .gray
    case 1.0:
      return .green
    default:
      return .black
    }
  }

  var progressText: String {
    let current = Int(progress * Double(activity.dailyGoal))
    return "\(current)/\(activity.dailyGoal)\(activity.metric)"
  }

  var body: some View {
    ZStack {
      // Base card
      RoundedRectangle(cornerRadius: 25)
        .fill(.thinMaterial)


      VStack {
        HStack {
          Text(streakText)
            .font(.caption)
            .foregroundColor(progressColor)
            .padding([.top, .trailing], 8)
          Spacer()
        }
        Spacer()
      }
      .padding(10)

      // Progress bar
      ShapeProgressBar(
        shape: RoundedRectangle(cornerRadius: 25),
        progress: progress,
        backgroundColor: .gray.opacity(0.1),
        color: progressColor,
        lineWidth: 3
      )
      .padding(2)

      // Content
      VStack {
        Spacer()
        Image(systemName: activity.icon)
          .font(.system(size: 60))
          .foregroundStyle(progressColor)

        Spacer()

        VStack(spacing: 4) {
          Text(activity.rawValue)
            .foregroundColor(progressColor)
            .font(.headline)
            .bold()

          Text(progressText)
            .contentTransition(.numericText())
            .font(.subheadline)
            .foregroundColor(progressColor.opacity(0.8))

        }
        .padding(.bottom)
      }
    }
    .onChange(of: progress) { newProgress, _ in
        streakManager.updateActivityStreak(activity: activity, completed: newProgress >= 1.0)
    }
    .animation(.spring(duration: 0.6), value: progress)
    .draggable(activity) {
      DragPreview(size: size)
        .onAppear { draggingItem = activity }
    }
    .dropDestination(for: Activities.self,
                     action: handleDropAction,
                     isTargeted: handleDropTarget)
  }

  func handleDropAction(items: [Activities], location: CGPoint) -> Bool {
    draggingItem = nil
    return false
  }

  func handleDropTarget(status: Bool) {
    if let draggingItem,
       status,
       draggingItem != activity,
       let sourceIndex = activities.firstIndex(of: draggingItem),
       let destinationIndex = activities.firstIndex(of: activity) {
      withAnimation(.bouncy) {
        let sourceItem = activities.remove(at: sourceIndex)
        activities.insert(sourceItem, at: destinationIndex)
      }
    }
  }
}

struct ActivityCard_Previews: View {
  @State private var progress: Double = 0.0
  @State private var activities: [Activities] = [.meditation, .breathing]
  @State private var draggingItem: Activities?

  var body: some View {
    VStack(spacing: 30) {
      ActivityCard(
        activity: .meditation,
        size: CGSize(width: 180, height: 200),
        draggingItem: $draggingItem,
        activities: $activities,
        progress: progress
      )
      .frame(width: 180, height: 200)

      VStack(spacing: 20) {
        HStack {
          Text("Progress: \(Int(progress * 100))%")
            .monospacedDigit()
          Spacer()
        }

        Slider(value: $progress, in: 0...1)
          .tint(
            progress == 0 ? .gray :
              progress >= 1.0 ? .green : .black
          )

        HStack {
          Button("Reset") {
            withAnimation {
              progress = 0
            }
          }

          Spacer()

          Button("Complete") {
            withAnimation {
              progress = 1.0
            }
          }
        }
      }
      .padding()
      .background {
        RoundedRectangle(cornerRadius: 12)
          .fill(.ultraThinMaterial)
      }
    }
    .padding()
  }
}

#Preview {
  ActivityCard_Previews()
    .environmentObject(StreakManager())
}
