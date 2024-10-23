//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Charts
import CloudKit
import SwiftUI

struct StatView: View {
    let items: StatData?

    @State var period: StatPeriod
    @EnvironmentObject var tint: Tint

    init(items: StatData?, period: StatPeriod) {
        self.items = items
        self._period = State(wrappedValue: period)
    }

    var body: some View {
        VStack {
            Picker("", selection: $period) {
                ForEach(StatPeriod.allCases) { period in
                    Text(period.shortTitle)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)

            if let counts = items?[period] {
                VStack {
                    StatChart(counts: counts, period: period)
                    Spacer()
                }
            } else {
                ProgressView().tint(nil).frame(maxHeight: .infinity)
            }
        }
        .navigationTitle("Stats")
        .onAppear {
            tint.value = nil
        }
    }
}

#Preview {
    NavigationStack {
        StatView(items: .example, period: .month).environmentObject(Tint())
    }
}

#Preview("Loading") {
    NavigationStack {
        StatView(items: [:], period: .month).environmentObject(Tint())
    }
}
