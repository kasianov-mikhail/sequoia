//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

@MainActor struct Uploader {
    let database: DatabaseProtocol
    let maxRetry: Int

    /// Uploads a given `SyncGroup` and `CKRecord` to the server.
    /// 
    /// This method uses recursion to handle specific types of errors, such as `CKError.serverRecordChanged`.
    /// If the error occurs, it will retry the upload with the server's version of the record or a new matrix
    /// if the maximum number of retries is exceeded.
    ///
    /// - Parameters:
    ///   - group: The `SyncGroup` to be uploaded.
    ///   - matrix: The `CKRecord` associated with the `SyncGroup`.
    /// 
    /// - Throws: An error if the upload fails after the specified number of retries.
    func upload(of group: SyncGroup, _ matrix: CKRecord, retry: Int = 1) async throws {
        for (field, count) in group.fields {
            let oldCount: Int = matrix[field] ?? 0
            matrix[field] = oldCount + count
        }

        do {
            try await database.save(matrix)
        } catch let error as CKError where error.code == CKError.serverRecordChanged {
            if retry > maxRetry {
                try await upload(of: group, group.newMatrix())
            } else if let serverMatrix = error.userInfo[CKRecordChangedErrorServerRecordKey]
                as? CKRecord
            {
                try await upload(of: group, serverMatrix, retry: retry + 1)
            } else {
                throw error
            }
        }

        try await database.modifyRecords(saving: group.events.map(toRecord), deleting: [])
    }
}
