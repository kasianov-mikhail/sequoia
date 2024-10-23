//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

/// A structure representing a filter for events.
/// This can be used to filter events based on various criteria.
struct EventFilter {
    var levels: Set<EventLevel> = Set(EventLevel.allCases)

    var text: String = ""

    var name: String = ""

    var userID: UUID?

    var sessionID: UUID?

    /// Generates an `NSPredicate` object based on the current filter criteria.
    /// 
    /// - Returns: An `NSPredicate` object that can be used to filter events.
    func predicate() -> NSPredicate {
        var predicates: [NSPredicate] = []

        if levels != Set(EventLevel.allCases) {
            predicates.append(.init(format: "level IN %@", levels.map(\.rawValue)))
        }

        if !text.isEmpty {
            predicates.append(.init(format: "name BEGINSWITH %@", text.lowercased()))
        }

        if !name.isEmpty {
            predicates.append(.init(format: "name == %@", name))
        }

        if let userID = userID?.uuidString {
            predicates.append(.init(format: "user_id == %@", userID))
        }

        if let sessionID = sessionID?.uuidString {
            predicates.append(.init(format: "session_id == %@", sessionID))
        }

        return NSCompoundPredicate(type: .and, subpredicates: predicates)
    }
}
