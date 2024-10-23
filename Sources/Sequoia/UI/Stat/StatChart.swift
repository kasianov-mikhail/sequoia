//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Charts
import SwiftUI

struct StatChart: View {
    let counts: [StatCount]
    let period: StatPeriod

    var body: some View {
        Chart(counts, id: \.0) { count in
            BarMark(
                x: .value("X", count.0, unit: period.component),
                y: .value("Y", count.1)
            )
            .foregroundStyle(.blue)
        }
        .chartXAxis {
            if period == .month {
                AxisMarks(
                    values: [-28, -21, -14, -7].map(period.range.upperBound.addingDay))
            } else {
                AxisMarks()
            }
        }
        .chartBackground { proxy in
            if counts.map(\.1).reduce(0, +) == 0 {
                Placeholder(text: "No results")
            }
        }
        .aspectRatio(4 / 3, contentMode: .fit)
        .padding()
    }
}

#Preview {
    StatChart(counts: .example, period: .month)
}

#Preview("Empty") {
    StatChart(counts: [], period: .month)
}
