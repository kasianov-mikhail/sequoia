//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct ParamList: View {
    let items: [ParamItem]

    @EnvironmentObject var tint: Tint

    var body: some View {
        List {
            ForEach(items) { item in
                ParamRow(item: item)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Params")
        .onAppear {
            tint.value = nil
        }
    }
}

#Preview {
    NavigationStack {
        ParamList(items: .example)
    }
}
