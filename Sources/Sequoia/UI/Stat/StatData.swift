//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

typealias StatData = [StatPeriod: [StatCount]]

extension StatData {
    static let example = StatPeriod.allCases.reduce(into: [:]) {
        $0[$1] = [(Date(), (0..<50).randomElement()!)]
    }
}
