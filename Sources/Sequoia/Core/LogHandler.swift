//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import Logging

public struct CKLogHandler: LogHandler {
    let label: String
    let container: CKContainer

    @Sendable public init(label: String, container: CKContainer) {
        self.label = label
        self.container = container
    }

    public var metadata: Logger.Metadata = [:]
    public var logLevel: Logger.Level = .info

    public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
        get { metadata[key] }
        set { metadata[key] = newValue }
    }

    public func log(
        level: Logger.Level,
        message: Logger.Message,
        metadata: Logger.Metadata?,
        source: String,
        file: String,
        function: String,
        line: UInt
    ) {
        Task {
            do {
                try await Sequoia.log(
                    message.description,
                    level: level,
                    metadata: metadata,
                    date: Date()
                )
                try await Sequoia.sync(container: container)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
