//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

/// A typealias representing the result of a database operation.
/// This typealias is used to simplify the representation of the result
/// returned from various database operations within the application.
typealias DatabaseResult = (
    saveResults: [CKRecord.ID: Result<CKRecord, any Error>],
    deleteResults: [CKRecord.ID: Result<Void, any Error>]
)

/// A protocol that defines the required methods and properties for a database.
/// Conforming types are expected to implement the necessary functionality to
/// interact with a database, including operations such as fetching, saving,
/// and deleting data.
protocol DatabaseProtocol {
    @discardableResult func save(_ record: CKRecord) async throws -> CKRecord

    @discardableResult
    /// Modifies records in the database by saving the specified records and deleting the specified record IDs.
    ///
    /// - Parameters:
    ///   - recordsToSave: An array of `CKRecord` objects that need to be saved to the database.
    ///   - recordIDsToDelete: An array of `CKRecord.ID` objects that need to be deleted from the database.
    func modifyRecords(saving recordsToSave: [CKRecord], deleting recordIDsToDelete: [CKRecord.ID])
        async throws -> DatabaseResult

    /// Fetches records from the database that match the specified query.
    ///
    /// - Parameters:
    ///   - query: The `CKQuery` object that defines the criteria for selecting records.
    ///   - desiredKeys: An optional array of `CKRecord.FieldKey` specifying the fields to be fetched. If `nil`, all fields are fetched.
    ///
    /// - Throws: An error if the operation fails.
    ///
    /// - Returns: An array of `CKRecord` objects that match the query.
    func records(matching query: CKQuery, desiredKeys: [CKRecord.FieldKey]?) async throws
        -> [CKRecord]
}

extension CKDatabase: DatabaseProtocol {
    func modifyRecords(saving recordsToSave: [CKRecord], deleting recordIDsToDelete: [CKRecord.ID])
        async throws -> DatabaseResult
    {
        try await modifyRecords(
            saving: recordsToSave,
            deleting: recordIDsToDelete,
            savePolicy: .ifServerRecordUnchanged,
            atomically: true
        )
    }

    func records(matching query: CKQuery, desiredKeys: [CKRecord.FieldKey]?) async throws
        -> [CKRecord]
    {
        let results = try await records(
            matching: query,
            desiredKeys: desiredKeys,
            resultsLimit: CKQueryOperation.maximumResults
        )

        var cursorOrNil = results.queryCursor
        var result = try results.matchResults.map { try $0.1.get() }

        while let cursor = cursorOrNil {
            let continuing = try await records(
                continuingMatchFrom: cursor,
                resultsLimit: CKQueryOperation.maximumResults
            )

            cursorOrNil = continuing.queryCursor
            result += try continuing.matchResults.map { try $0.1.get() }
        }

        return result
    }
}
