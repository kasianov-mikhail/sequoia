//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

extension Date {
    var startOfHour: Date {
        Calendar.UTC.dateComponents([.calendar, .year, .month, .day, .hour], from: self).date!
    }

    var startOfWeek: Date {
        Calendar.UTC.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
}

extension Date {
    func adding(_ component: Calendar.Component, value: Int = 1) -> Date {
        Calendar.UTC.date(byAdding: component, value: value, to: self)!
    }

    func addingDay(_ value: Int = 1) -> Date {
        Calendar.UTC.date(byAdding: .day, value: value, to: self)!
    }

    func addingHour(_ value: Int = 1) -> Date {
        Calendar.UTC.date(byAdding: .hour, value: value, to: self)!
    }

    func addingWeek(_ value: Int = 1) -> Date {
        Calendar.UTC.date(byAdding: .weekOfYear, value: value, to: self)!
    }

    func addingMonth(_ value: Int = 1) -> Date {
        Calendar.UTC.date(byAdding: .month, value: value, to: self)!
    }

    func addingYear(_ value: Int = 1) -> Date {
        Calendar.UTC.date(byAdding: .year, value: value, to: self)!
    }
}
