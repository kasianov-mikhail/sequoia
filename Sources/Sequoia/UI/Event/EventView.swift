//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

@available(iOS 17.0, *)
struct EventView: View {
    let event: Event
    let showHistory: Bool

    @State private var presentedParams: [ParamItem]?
    @EnvironmentObject var tint: Tint

    init(event: Event, showHistory: Bool) {
        self.event = event
        self.showHistory = showHistory
    }

    var body: some View {
        let color = event.level?.color

        List {
            EventHeader(event: event)

            if let paramCount = event.paramCount, paramCount > 0 {
                ParamSection(
                    count: paramCount,
                    presented: $presentedParams,
                    param: Param(recordID: event.id)
                )
            }

            StatSection(eventName: event.name)

            if showHistory {
                HistorySection(event: event)
            }
        }
        .onAppear {
            tint.value = color
        }
        .onDisappear {
            tint.value = nil
        }
        .navigationDestination(item: $presentedParams) { items in
            ParamList(items: items)
        }
        .listStyle(.plain)
        .toolbarBackground(color?.opacity(0.12) ?? .clear, for: .navigationBar)
        .toolbarBackground(color == nil ? .automatic : .visible, for: .navigationBar)
        .navigationTitle(event.name)
    }
}

#Preview {
    NavigationStack {
        if #available(iOS 17.0, *) {
            EventView(event: .example(), showHistory: true)
        }
    }
    .environmentObject(Tint())
}
