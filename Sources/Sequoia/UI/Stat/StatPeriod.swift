//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

enum StatPeriod: String, CaseIterable, Identifiable {
    case today
    case yesterday
    case week
    case month
    case year

    var id: Self { self }

    var title: String {
        switch self {
        case .today:
            "Today"
        case .yesterday:
            "Yesterday"
        case .week:
            "Last 7 days"
        case .month:
            "Last 30 days"
        case .year:
            "Last 365 days"
        }
    }

    var shortTitle: String {
        switch self {
        case .today:
            "T"
        case .yesterday:
            "Y"
        case .week:
            "7"
        case .month:
            "30"
        case .year:
            "365"
        }
    }

    var range: Range<Date> {
        let today = Calendar(identifier: .iso8601).startOfDay(for: Date())

        return switch self {
        case .today:
            today..<today.addingDay()
        case .yesterday:
            today.addingDay(-1)..<today
        case .week:
            today.addingWeek(-1)..<today
        case .month:
            today.addingMonth(-1)..<today
        case .year:
            today.addingYear(-1)..<today
        }
    }

    var component: Calendar.Component {
        switch self {
        case .today, .yesterday:
            .hour
        case .week, .month:
            .day
        case .year:
            .month
        }
    }
}
