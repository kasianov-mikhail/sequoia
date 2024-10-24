//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

@testable import Sequoia

class DatabaseMock: DatabaseProtocol {
    var records: [CKRecord] = []
    var errors: [Error] = []
    var result = DatabaseResult([:], [:])

    func save(_ record: CKRecord) async throws -> CKRecord {
        if let error = errors.popLast() {
            throw error
        } else {
            records.append(record)
            return record
        }
    }

    func modifyRecords(saving recordsToSave: [CKRecord], deleting recordIDsToDelete: [CKRecord.ID])
        async throws -> DatabaseResult
    {
        return result
    }

    func records(matching query: CKQuery, desiredKeys: [CKRecord.FieldKey]?) async throws
        -> [CKRecord]
    {
        let predicate = query.predicate
        predicate.allowEvaluation()
        return records.filter(predicate.evaluate)
    }
}
