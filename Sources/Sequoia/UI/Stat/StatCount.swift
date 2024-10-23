//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit

typealias StatCount = (Date, Int)

extension [StatCount] {
    static var example: [StatCount] {
        (0..<30).map { i in
            (Date().startOfHour.addingDay(-i), .random(in: 0...50))
        }
    }
}
