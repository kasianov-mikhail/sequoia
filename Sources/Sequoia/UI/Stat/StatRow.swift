//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct StatRow: View {
    let items: StatData?
    let period: StatPeriod

    var body: some View {
        ZStack {
            HStack {
                Text(period.title).monospaced(false)
                Spacer()

                if let count {
                    Text(count == 0 ? "—" : "\(count)")
                } else {
                    Redacted(length: 5)
                }
            }
            .foregroundStyle(.blue)

            NavigationLink {
                StatView(items: items, period: period)
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
        .alignmentGuide(.listRowSeparatorTrailing) { dimension in
            dimension[.trailing]
        }
    }

    var count: Int? {
        items?[period]?.map(\.1).reduce(0, +)
    }
}

#Preview {
    List {
        StatRow(items: .example, period: .month)
    }
    .listStyle(.plain)
}
