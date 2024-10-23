//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

@MainActor class Stat: ObservableObject {
    let eventName: String

    @Published var data: StatData?

    init(eventName: String) {
        self.eventName = eventName
    }

    func fetchIfNeeded(in container: CKContainer) async {
        if data == nil {
            await fetch(in: container)
        }
    }

    private func fetch(in container: CKContainer) async {
        let today = Calendar(identifier: .iso8601).startOfDay(for: Date())
        let yearAgo = today.addingYear(-1).addingWeek(-1)
        let predicate = NSPredicate(
            format: "date >= %@ AND name == %@",
            yearAgo.addingWeek(-1) as NSDate,
            eventName
        )
        let query = CKQuery(recordType: "DateIntMatrix", predicate: predicate)

        do {
            let records = try await container.publicCloudDatabase.records(
                matching: query,
                desiredKeys: nil
            )
            let pairs = records.flatMap(toCount)
            data = Dictionary(pairs, uniquingKeysWith: +).grouped
        } catch {
            assertionFailure(error.localizedDescription)
            data = nil
        }
    }

    func toCount(record: CKRecord) -> [StatCount] {
        guard let date = record["date"] as? Date else {
            return []
        }

        let keys = record.allKeys().filter {
            $0.starts(with: "cell_")
        }

        return record.dictionaryWithValues(forKeys: keys).compactMapValues {
            $0 as? Int
        }.map { key, value in
            (addingDate(from: key, to: date), value)
        }
    }

    private func addingDate(from field: String, to date: Date) -> Date {
        let raw = field.components(separatedBy: "_")

        guard raw.count == 3, let day = Int(raw[1]), let hour = Int(raw[2]) else {
            return date
        }

        return date.addingDay(day - 1).addingHour(hour)
    }
}
