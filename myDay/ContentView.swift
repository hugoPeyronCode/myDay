//
//  ContentView.swift
//  myDay
//
//  Created by Hugo Peyron on 03/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

enum Activities: String, Transferable, Codable {
  case meditation = "meditation"
  case journaling = "journaling"
  case tango = "tango"
  case pushUps = "push ups"
  case abdoToning = "adbo toning"

  var color: Color {
    switch self {
    case .meditation: return .gray
    case .journaling: return .gray
    case .tango: return .gray
    case .pushUps: return .gray
    case .abdoToning: return .gray
    }
  }

  static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .activity)
  }

}

extension UTType {
  static var activity: UTType { UTType(exportedAs: "com.yourapp.activity") }
}

struct ContentView: View {
  @State private var activities: [Activities] = [.meditation, .journaling, .tango, .pushUps, .abdoToning]
  @State private var draggingItem: Activities?

  var body: some View {
    NavigationStack {
      ActivityGrid(activities: $activities, draggingItem: $draggingItem)
        .navigationTitle("MyDay")
    }
  }
}

struct ActivityGrid: View {
  @Binding var activities: [Activities]
  @Binding var draggingItem: Activities?
  let columnsCount = 2

  var body: some View {
    ScrollView {
      LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: columnsCount), spacing: 10) {
        ForEach(activities, id: \.self) { activity in
          GeometryReader { geometry in
            ActivityCard(
              activity: activity,
              size: geometry.size,
              draggingItem: $draggingItem,
              activities: $activities
            )
          }
          .frame(height: UIScreen.main.bounds.height * 0.2)
        }
      }
      .padding()
    }
  }
}

struct ActivityCard: View {
  let activity: Activities
  let size: CGSize
  @Binding var draggingItem: Activities?
  @Binding var activities: [Activities]

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25)
        .fill(activity.color)

      Text(activity.rawValue)
        .foregroundColor(.white)
        .bold()
    }
    .draggable(activity) {
      DragPreview(size: size)
        .onAppear { draggingItem = activity }
    }
    .dropDestination(for: Activities.self,
                     action: handleDropAction,
                     isTargeted: handleDropTarget)
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

private extension ActivityCard {
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

#Preview {
  ContentView()
}
