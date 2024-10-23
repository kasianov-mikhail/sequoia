//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import SwiftUI

@available(iOS 17.0, *)
struct EventList: View {
    let timeline = Date()

    @ObservedObject var analytics: Analytics
    @Environment(\.eventHistory) var showHistory: Bool
    @EnvironmentObject var container: CKContainer

    var body: some View {
        if let events = analytics.events {
            if events.isEmpty {
                Placeholder(text: "No results")
            } else {
                List {
                    ForEach(events) { event in
                        EventRow(event: event, timeline: timeline)
                    }

                    if let cursor = analytics.cursor {
                        ProgressView()
                            .task {
                                await analytics.fetchMore(cursor: cursor, in: container)
                            }
                            .id(UUID())
                            .frame(height: 72)
                            .frame(maxWidth: .infinity)
                            .listRowSeparator(.hidden, edges: .bottom)
                    }
                }
                .listStyle(.plain)
                .animation(nil, value: UUID())
            }
        } else {
            ProgressView().frame(maxHeight: .infinity)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    NavigationStack {
        let analytics = Analytics()
        analytics.events = .example
        return EventList(analytics: analytics).navigationTitle("Events")
    }
    .environmentObject(Tint())
}
