//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import Logging

struct Event: Identifiable {
    let name: String
    let level: Logger.Level?
    let date: Date?
    let paramCount: Int?
    let uuid: UUID?
    let id: CKRecord.ID
    let userID: UUID?
    let sessionID: UUID?
}

extension Event {
    static let keys = [
        "name",
        "level",
        "date",
        "param_count",
        "uuid",
        "user_id",
        "session_id",
    ]

    init(results: (CKRecord.ID, Result<CKRecord, Error>)) throws {
        try self.init(record: results.1.get())
    }

    init(record: CKRecord) throws {
        name = record["name"]!
        level = record["level"].flatMap { EventLevel(rawValue: $0) }
        date = record["date"]
        paramCount = record["param_count"]
        uuid = record["uuid"].flatMap { UUID(uuidString: $0) }
        id = record.recordID
        userID = record["user_id"].flatMap { UUID(uuidString: $0) }
        sessionID = record["session_id"].flatMap { UUID(uuidString: $0) }
    }
}

extension Event {
    static func example(level: EventLevel = .warning, date: Date = Date()) -> Event {
        Event(
            name: "event_name",
            level: level,
            date: date,
            paramCount: 8,
            uuid: UUID(),
            id: .example(),
            userID: UUID(),
            sessionID: UUID()
        )
    }
}

extension [Event] {
    static let example: [Event] = EventLevel.allCases.enumerated().map { i, level in
        .example(level: level, date: Date() - 3600 * TimeInterval(i))
    }
}

extension CKRecord.ID {
    static func example() -> CKRecord.ID {
        CKRecord(recordType: "Event").recordID
    }
}
