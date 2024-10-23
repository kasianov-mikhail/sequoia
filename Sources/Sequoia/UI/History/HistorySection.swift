//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

@available(iOS 17.0, *)
struct HistorySection: View {
    let event: Event

    var body: some View {
        Header(title: "History")

        ForEach(HistoryTab.allCases) { tab in
            row(tab: tab)
        }
    }

    func row(tab: HistoryTab) -> some View {
        ZStack {
            HStack {
                Text(tab.title).foregroundStyle(.blue)
                Spacer()
            }

            NavigationLink {
                if let filter = HistoryFilter(event: event, tab: tab) {
                    HistoryView(filter: filter)
                }
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
        .alignmentGuide(.listRowSeparatorTrailing) { dimension in
            dimension[.trailing]
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    List {
        HistorySection(event: .example())
    }
    .listStyle(.plain)
}
