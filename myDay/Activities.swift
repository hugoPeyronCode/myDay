//
//  Activities.swift
//  myDay
//
//  Created by Hugo Peyron on 04/02/2025.
//

import SwiftUI
import UniformTypeIdentifiers

enum Activities: String, Transferable, Codable {
    case meditation = "meditation"
    case journaling = "journaling"
    case tango = "tango"
    case pushUps = "push ups"
    case abdoToning = "adbo toning"
    case focus = "focus"
    case breathing = "breathing"

    var color: Color {
        switch self {
        case .meditation: return .gray
        case .journaling: return .gray
        case .tango: return .gray
        case .pushUps: return .gray
        case .abdoToning: return .gray
        case .focus: return .gray
        case .breathing: return .gray
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
        }
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .activity)
    }
}

extension UTType {
    static var activity: UTType { UTType(exportedAs: "com.yourapp.activity") }
}
