//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

extension Array {
    func unique(by path: KeyPath<Element, String>, max: Int) -> [String] {
        let all = reduce(into: [:]) { dict, event in
            dict[event[keyPath: path]] = (dict[event[keyPath: path]] ?? 0) + 1
        }
        .sorted { lhs, rhs in
            lhs.value > rhs.value
        }
        .map(\.key)

        return Array<String>(all.prefix(max))
    }
}
