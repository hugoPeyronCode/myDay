//
//  Activities.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

enum Activities: String, CaseIterable, Transferable, Codable {
  case meditation = "meditation"
  case journaling = "journaling"
  case tango = "tango"
  case pushUps = "push ups"
  case abdoToning = "adbo toning"
  case focus = "focus"
  case breathing = "breathing"
  case doNothing = "Do Nothing"

  var color: Color {
    switch self {
    case .meditation: return .gray
    case .journaling: return .gray
    case .tango: return .gray
    case .pushUps: return .gray
    case .abdoToning: return .gray
    case .focus: return .gray
    case .breathing: return .gray
    case .doNothing: return .gray
    }
  }
  
  var icon: String {
    switch self {
    case .meditation: return "figure.mind.and.body"
    case .journaling: return "text.book.closed"
    case .tango: return "moonphase.waxing.gibbous.inverse"
    case .pushUps: return "figure.strengthtraining.traditional"
    case .abdoToning: return "figure.core.training"
    case .focus: return "brain.head.profile"
    case .breathing: return "lungs"
    case .doNothing: return "circle.dotted.circle"
    }
  }

  var metric: String {
      switch self {
      case .meditation: return "min"
      case .journaling: return "words"
      case .tango: return "min"
      case .pushUps: return "reps"
      case .abdoToning: return "min"
      case .focus: return "min"
      case .breathing: return "min"
      case .doNothing: return "min"
      }
  }

  var dailyGoal: Int {
      switch self {
      case .meditation: return 15
      case .journaling: return 300
      case .tango: return 30
      case .pushUps: return 30
      case .abdoToning: return 5
      case .focus: return 25
      case .breathing: return 10
      case .doNothing: return 5
      }
  }
  
  static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation(contentType: .activity)
  }
}

extension UTType {
  static var activity: UTType { UTType(exportedAs: "com.yourapp.activity") }
}
