//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import SwiftUI

class Tint: ObservableObject {
    @Published var value: Color?
}

@available(iOS 17.0, *)
public struct AnalyticsView: View {
    let container: CKContainer

    @State private var filter = EventFilter()

    @StateObject private var analytics = Analytics()
    @StateObject private var search = Analytics()
    @StateObject private var tint = Tint()

    @Environment(\.dismiss) var dismiss

    public init(container: CKContainer) {
        self.container = container
    }

    public var body: some View {
        NavigationStack {
            Group {
                if !filter.text.isEmpty {
                    EventList(analytics: search)
                } else {
                    AnalyticsList(filter: $filter, analytics: analytics)
                }
            }
            .searchable(text: $filter.text)
            .autocorrectionDisabled(true)  // stop keyboard suggestions
            .keyboardType(.alphabet)  // stop keyboard suggestions
            .searchSuggestions {
                if let events = analytics.events, filter.text.isEmpty {
                    ForEach(events.unique(by: \.name, max: 7), id: \.self) {
                        Suggestion(text: $0)
                    }
                }
            }
            .onSubmit(of: .search) {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )  // hide keyboard on suggestion selected

                Task {
                    search.events = nil
                    await search.fetch(for: filter, in: container)
                }
            }
            .onChange(of: filter.text) {
                search.events?.removeAll()
            }
            .navigationTitle("Events")
        }
        .environmentObject(container)
        .environmentObject(tint)
        .tint(tint.value)
    }
}

extension CKContainer: @retroactive ObservableObject {}
