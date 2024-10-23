//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import CoreData

@MainActor
struct SyncSession {
    let provider: MatrixProvider
    let uploader: Uploader

    func sync(in context: NSManagedObjectContext) async throws {
        while let group = try SyncGroup.group(in: context) {
            let matrix = try await provider.matrixRecord(of: group)

            try await uploader.upload(of: group, matrix)

            for event in group.events {
                context.delete(event)
            }
            try context.save()
        }
    }
}

extension Date {
    var field: String {
        let week = Calendar.UTC.component(.weekday, from: self)
        let hour = Calendar.UTC.component(.hour, from: self)
        let components = ["cell", String(week), String(format: "%02d", hour)]
        return components.joined(separator: "_")
    }
}
