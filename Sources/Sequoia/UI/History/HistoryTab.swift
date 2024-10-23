//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

enum HistoryTab: CaseIterable, Identifiable {
    case user
    case session

    var id: Self { self }

    var title: String {
        switch self {
        case .user:
            "User"
        case .session:
            "Session"
        }
    }
}
