//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

@MainActor class Analytics: ObservableObject {
    @Published var events: [Event]?
    @Published var cursor: CKQueryOperation.Cursor?

    func fetch(for filter: EventFilter, in container: CKContainer) async {
        do {
            let query = CKQuery(recordType: "Event", predicate: filter.predicate())
            query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

            let results = try await container.publicCloudDatabase.records(
                matching: query,
                desiredKeys: Event.keys,
                resultsLimit: 50
            )

            self.cursor = results.queryCursor
            self.events = try results.matchResults.map(Event.init)
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }

    func fetchMore(cursor: CKQueryOperation.Cursor, in container: CKContainer) async {
        do {
            let results = try await container.publicCloudDatabase.records(
                continuingMatchFrom: cursor
            )

            self.cursor = results.queryCursor
            self.events?.append(contentsOf: try results.matchResults.map(Event.init))
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}
