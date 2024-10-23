//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import CoreData

struct SyncGroup: Equatable {
    let name: String
    let week: Date
    let events: [EventModel]
    let fields: [String: Int]

    func newMatrix() -> CKRecord {
        let matrix = CKRecord(recordType: "DateIntMatrix")
        matrix["name"] = name
        matrix["date"] = week
        return matrix
    }

    static func group(in context: NSManagedObjectContext) throws -> SyncGroup? {
        let eventRequest = EventModel.fetchRequest()
        eventRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        eventRequest.fetchLimit = 1

        guard let event = try context.fetch(eventRequest).first else {
            return nil
        }
        guard let name = event.name, let week = event.week else {
            return nil
        }

        let groupRequest = EventModel.fetchRequest()
        groupRequest.predicate = NSPredicate(
            format: "name == %@ AND week == %@", name, week as NSDate)

        let events = try context.fetch(groupRequest)
        let fields = Dictionary(grouping: events, by: \.hour!.field).mapValues(\.count)

        return SyncGroup(name: name, week: week, events: events, fields: fields)
    }
}
