//
//  ActivityGridView.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI

//struct ActivityGridView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    ActivityGridView()
//}

import SwiftUI

struct ActivityGrid: View {
    @Binding var activities: [Activities]
    @Binding var draggingItem: Activities?
    @Binding var activitiesProgress: [Activities: Double]
    let columnsCount = 2

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
