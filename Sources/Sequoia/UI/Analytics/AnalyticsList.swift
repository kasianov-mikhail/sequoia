//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import SwiftUI

@available(iOS 17.0, *)
struct AnalyticsList: View {
    @Binding var filter: EventFilter
    @ObservedObject var analytics: Analytics
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: CKContainer

    var body: some View {
        EventList(analytics: analytics)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    FilterButton(levels: $filter.levels)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .tint(.blue)
                }
            }
            .task {
                await fetch()
            }
            .refreshable {
                await fetch()
            }
            .onChange(of: filter.levels) { _, levels in
                Task {
                    analytics.events = nil
                    await fetch()
                }
            }
    }

    func fetch() async {
        await analytics.fetch(for: filter, in: container)
    }
}
