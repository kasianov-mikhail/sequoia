//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI
import CloudKit

struct StatSection: View {
    @StateObject var stat: Stat
    @EnvironmentObject var container: CKContainer

    init(eventName: String) {
        _stat = StateObject(wrappedValue: Stat(eventName: eventName))
    }

    var body: some View {
        Header(title: "Stats").task {
            await stat.fetchIfNeeded(in: container)
        }

        ForEach(StatPeriod.allCases) { period in
            StatRow(items: stat.data, period: period)
        }
    }
}

#Preview {
    List {
        let view = StatSection(eventName: "event_name")
        view.stat.data = .example
        return view
    }
    .listStyle(.plain)
}
