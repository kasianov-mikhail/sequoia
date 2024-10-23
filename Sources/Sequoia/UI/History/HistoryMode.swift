//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

enum HistoryMode: Identifiable {
    case event
    case all

    var id: Self { self }

    var title: String {
        switch self {
        case .event:
            "Event"
        case .all:
            "All"
        }
    }

    mutating func toggle() {
        switch self {
        case .event:
            self = .all
        case .all:
            self = .event
        }
    }
}
