//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

func toRecord(event: EventModel) -> CKRecord {
    let record = CKRecord(recordType: "Event")

    record["params"] = event.params
    record["param_count"] = event.paramCount
    record["name"] = event.name
    record["level"] = event.level
    record["date"] = event.date
    record["hour"] = event.hour
    record["week"] = event.week
    record["uuid"] = event.uuid?.uuidString
    record["version"] = 1
    record["user_id"] = event.userID?.uuidString
    record["session_id"] = event.sessionID?.uuidString

    return record
}
