//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

@MainActor class Param: ObservableObject {
    let recordID: CKRecord.ID

    @Published var items: [ParamItem]?

    init(recordID: CKRecord.ID) {
        self.recordID = recordID
    }

    func fetchIfNeeded(in container: CKContainer) async {
        if items == nil {
            await fetch(in: container)
        }
    }

    private func fetch(in container: CKContainer) async {
        do {
            items = try await container.publicCloudDatabase
                .record(for: recordID)["params"]
                .map(toItems)?
                .sorted()
        } catch {
            assertionFailure(error.localizedDescription)
            items = nil
        }
    }
}

private func toItems(data: Data) throws -> [ParamItem] {
    try JSONDecoder().decode([String: String].self, from: data).map(ParamItem.init)
}
