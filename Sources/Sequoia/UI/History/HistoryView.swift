//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI
import CloudKit

@available(iOS 17.0, *)
struct HistoryView: View {
    @EnvironmentObject var tint: Tint
    @EnvironmentObject var container: CKContainer

    @State private var filter: HistoryFilter
    @StateObject var analytics = Analytics()

    init(filter: HistoryFilter) {
        _filter = State(wrappedValue: filter)
    }

    var body: some View {
        VStack {
            Picker("", selection: $filter.tab) {
                ForEach(HistoryTab.allCases) { period in
                    Text(period.title)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)

            EventList(analytics: analytics)
                .frame(maxHeight: .infinity)
                .environment(\.eventHistory, false)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    filter.mode.toggle()
                } label: {
                    Text(filter.mode.title)
                }
            }
        }
        .onAppear {
            tint.value = nil
        }
        .task {
            await fetch()
        }
        .refreshable {
            await fetch()
        }
        .onChange(of: filter.tab) {
            Task {
                analytics.events = nil
                await fetch()
            }
        }
        .onChange(of: filter.mode) {
            Task {
                analytics.events = nil
                await fetch()
            }
        }
        .navigationTitle("History")
    }

    func fetch() async {
        let filter = filter.produce()
        await analytics.fetch(for: filter, in: container)
    }
}

@available(iOS 17.0, *)
#Preview {
    NavigationStack {
        let view = HistoryView(filter: .example)
        view.analytics.events = .example
        return view.environmentObject(Tint())
    }
}
