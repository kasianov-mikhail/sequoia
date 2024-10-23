//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import SwiftUI

struct ParamSection: View {
    let count: Int

    @Binding var presented: [ParamItem]?
    @StateObject var param: Param
    @EnvironmentObject var container: CKContainer

    init(count: Int, presented: Binding<[ParamItem]?>, param: Param) {
        self.count = count
        self._presented = presented
        self._param = StateObject(wrappedValue: param)
    }

    var body: some View {
        Header(title: "Params", action: seeAll).task {
            await param.fetchIfNeeded(in: container)
        }

        if let items = param.items {
            ForEach(items.prefix(3)) { item in
                ParamRow(item: item)
            }
        } else {
            ForEach(0..<min(3, count), id: \.self) { _ in
                ParamRow(item: nil)
            }
        }
    }

    var seeAll: (() -> Void)? {
        if let items = param.items, count > 3 {
            return { presented = items }
        } else {
            return nil
        }
    }
}

#Preview {
    List {
        let param = Param(recordID: .example())
        param.items = .example
        return ParamSection(count: 3, presented: .constant(nil), param: param)
    }
    .listStyle(.plain)
}
