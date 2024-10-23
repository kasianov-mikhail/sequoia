//
//  EventHistory.swift
//  Sequoia
//
//  Created by Михаил Касьянов on 14.10.2024.
//


import SwiftUI

struct EventHistory: EnvironmentKey {
    static let defaultValue = true
}

extension EnvironmentValues {
    var eventHistory: Bool {
        get { self[EventHistory.self] }
        set { self[EventHistory.self] = newValue }
    }
}
