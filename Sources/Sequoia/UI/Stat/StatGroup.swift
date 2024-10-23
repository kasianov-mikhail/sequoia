//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

extension [Date: Int] {
    var grouped: [StatPeriod: [StatCount]] {
        StatPeriod.allCases.reduce(into: [:]) {
            $0[$1] = grouped(by: $1)
        }
    }

    private func grouped(by period: StatPeriod) -> [StatCount] {
        var result: [StatCount] = []
        var date = period.range.lowerBound

        while period.range.contains(date) {
            let next = date.adding(period.component)

            let count = filter { key, value in
                (date..<next).contains(key)
            }.reduce(0) {
                $0 + $1.value
            }

            result.append((date, count))
            date = next
        }

        return result
    }
}
