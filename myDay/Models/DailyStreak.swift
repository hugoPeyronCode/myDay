//
//  DailyStreak.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import Foundation

struct ActivityStreak: Codable {
  var currentStreak: Int
  var lastCompletionDate: Date?
  var bestStreak: Int

  init(currentStreak: Int = 0, lastCompletionDate: Date? = nil, bestStreak: Int = 0) {
    self.currentStreak = currentStreak
    self.lastCompletionDate = lastCompletionDate
    self.bestStreak = bestStreak
  }

  mutating func updateStreak(completed: Bool) {
    let calendar = Calendar.current
    let today = Date()

    guard let lastDate = lastCompletionDate else {
      if completed {
        currentStreak = 1
        lastCompletionDate = today
        bestStreak = max(bestStreak, currentStreak)
      }
      return
    }

    let isConsecutiveDay = calendar.isDate(lastDate, inSameDayAs: today) ||
    calendar.isDate(lastDate, equalTo: calendar.date(byAdding: .day, value: -1, to: today)!, toGranularity: .day)

    if completed && isConsecutiveDay {
      if !calendar.isDate(lastDate, inSameDayAs: today) {
        currentStreak += 1
        lastCompletionDate = today
        bestStreak = max(bestStreak, currentStreak)
      }
    } else if !isConsecutiveDay {
      currentStreak = completed ? 1 : 0
      lastCompletionDate = completed ? today : nil
    }
  }
}

class StreakManager: ObservableObject {
  @Published var activityStreaks: [Activities: ActivityStreak] = [:]
  @Published var perfectDayStreak: ActivityStreak = ActivityStreak()

  init() {
    loadStreaks()
  }

  func updateActivityStreak(activity: Activities, completed: Bool) {
    print("Updating streak for \(activity): completed=\(completed)")
    print("Current streak: \(activityStreaks[activity]?.currentStreak ?? 0)")
    print("Last completion: \(activityStreaks[activity]?.lastCompletionDate?.description ?? "nil")")
    var streak = activityStreaks[activity] ?? ActivityStreak()
    streak.updateStreak(completed: completed)
    activityStreaks[activity] = streak
    saveStreaks()
    checkPerfectDay()
  }

  private func checkPerfectDay() {
    let allActivitiesCompleted = Activities.allCases.allSatisfy { activity in
      activityStreaks[activity]?.lastCompletionDate.map { Calendar.current.isDateInToday($0) } ?? false
    }

    perfectDayStreak.updateStreak(completed: allActivitiesCompleted)
    saveStreaks()
  }

  private func saveStreaks() {
    // Save to UserDefaults or other persistence
    if let encoded = try? JSONEncoder().encode(activityStreaks) {
      UserDefaults.standard.set(encoded, forKey: "activityStreaks")
    }
    if let encoded = try? JSONEncoder().encode(perfectDayStreak) {
      UserDefaults.standard.set(encoded, forKey: "perfectDayStreak")
    }
  }

  private func loadStreaks() {
    // Load from UserDefaults or other persistence
    if let savedStreaks = UserDefaults.standard.data(forKey: "activityStreaks"),
       let decoded = try? JSONDecoder().decode([Activities: ActivityStreak].self, from: savedStreaks) {
      activityStreaks = decoded
    }
    if let savedPerfectStreak = UserDefaults.standard.data(forKey: "perfectDayStreak"),
       let decoded = try? JSONDecoder().decode(ActivityStreak.self, from: savedPerfectStreak) {
      perfectDayStreak = decoded
    }
  }
}
