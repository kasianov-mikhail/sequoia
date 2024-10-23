//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

@MainActor
private var isSyncing = false

@MainActor func sync(container: CKContainer) async throws {
    guard try await container.accountStatus() == .available else {
        return
    }

    if !isSyncing {
        isSyncing = true
        defer { isSyncing = false }
        try await sync(database: container.publicCloudDatabase)
    }
}

private func sync(database: DatabaseProtocol) async throws {
    let provider = MatrixProvider(database: database)
    let uploader = Uploader(database: database, maxRetry: 3)
    let session = SyncSession(provider: provider, uploader: uploader)
    try await session.sync(in: persistentContainer.viewContext)
}
