//
//  ActivityCard.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI

struct ActivityCard: View {
    let activity: Activities
    let size: CGSize
    @Binding var draggingItem: Activities?
    @Binding var activities: [Activities]
    let progress: Double

    var progressColor: Color {
        progress >= 1.0 ? .green : .blue
    }

    var body: some View {
        ZStack {
            // Base card
            RoundedRectangle(cornerRadius: 25)
                .fill(.thinMaterial)

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
                Text(activity.rawValue)
                    .foregroundColor(activity.color)
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom)
            }
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
                    .tint(progress >= 1.0 ? .green : .blue)

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
}
