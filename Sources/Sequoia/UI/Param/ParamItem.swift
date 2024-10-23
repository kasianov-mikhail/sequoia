//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import Foundation

struct ParamItem: Identifiable, Comparable, Hashable {
    static func < (lhs: ParamItem, rhs: ParamItem) -> Bool {
        lhs.key < rhs.key
    }

    let key: String
    let value: String

    var id: String { key }
}

extension ParamItem {
    static let example = ParamItem(key: "IP", value: "5.7.5.8")
}

extension [ParamItem] {
    static let example: [ParamItem] = [
        .init(key: "IP", value: "5.7.5.8"),
        .init(key: "City", value: "Munich"),
        .init(key: "Region", value: "Bavaria"),
        .init(key: "Country", value: "🇩🇪 DE"),
        .init(key: "Location", value: "48.1776, 11.5169"),
        .init(key: "Organisation", value: "AS6805 Telefonica Germany GmbH & Co.OHG"),
        .init(key: "Postal", value: "80992"),
        .init(key: "Timezone", value: "Europe/Berlin"),
    ]
}
