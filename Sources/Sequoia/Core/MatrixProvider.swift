//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import CoreData

struct MatrixProvider {
    let database: DatabaseProtocol

    func matrixRecord(of group: SyncGroup) async throws -> CKRecord {
        let namePredicate = NSPredicate(format: "name == %@", group.name)
        let datePredicate = NSPredicate(format: "date == %@", group.week as NSDate)
        let predicate = NSCompoundPredicate(
            type: .and, subpredicates: [namePredicate, datePredicate])

        let query = CKQuery(recordType: "DateIntMatrix", predicate: predicate)
        let desiredKeys = group.fields.map(\.key)

        let allMatrices = try await database.records(matching: query, desiredKeys: desiredKeys)
        let matrix = allMatrices.randomElement() ?? group.newMatrix()

        return matrix
    }
}
