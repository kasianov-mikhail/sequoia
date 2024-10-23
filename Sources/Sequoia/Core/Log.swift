//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import CoreData
import Logging

@MainActor func log(_ name: String, level: Logger.Level, metadata: Logger.Metadata?, date: Date)
    throws
{
    let context = persistentContainer.viewContext
    let event = EventModel(context: context)

    event.date = date
    event.hour = date.startOfHour
    event.week = date.startOfWeek
    event.level = level.rawValue
    event.name = name
    event.uuid = UUID()

    if let params = metadata?.compactMapValues(\.stringValue) {
        event.params = try JSONEncoder().encode(params)
        event.paramCount = Int64(params.count)
    }

    event.userID = IDs.user
    event.sessionID = IDs.session

    try context.save()
}

extension Logger.MetadataValue {
    fileprivate var stringValue: String? {
        switch self {
        case .string(let string):
            string
        case .stringConvertible(let convertible):
            convertible.description
        case .array:
            nil
        case .dictionary:
            nil
        }
    }
}
