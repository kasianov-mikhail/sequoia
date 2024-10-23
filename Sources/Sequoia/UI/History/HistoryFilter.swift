//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct HistoryFilter {
    let name: String
    let userID: UUID
    let sessionID: UUID
    var tab: HistoryTab

    var mode = HistoryMode.event

    func produce() -> EventFilter {
        let name =
            switch mode {
            case .event:
                name
            case .all:
                ""
            }

        let eventFilter =
            switch tab {
            case .user:
                EventFilter(name: name, userID: userID)
            case .session:
                EventFilter(name: name, sessionID: sessionID)
            }

        return eventFilter
    }
}

extension HistoryFilter {
    init?(event: Event, tab: HistoryTab) {
        guard let userID = event.userID, let sessionID = event.sessionID else {
            return nil
        }

        self.name = event.name
        self.userID = userID
        self.sessionID = sessionID
        self.tab = tab
    }
}

extension HistoryFilter {
    static var example: Self {
        .init(name: "event_name", userID: UUID(), sessionID: UUID(), tab: .user)
    }
}
