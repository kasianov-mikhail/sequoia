//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct ParamView: View {
    let item: ParamItem

    @EnvironmentObject var tint: Tint

    var body: some View {
        ScrollView {
            Text(item.value)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .monospaced()
                .navigationTitle(item.key)
            Spacer()
        }
        .onAppear {
            tint.value = nil
        }
    }
}

#Preview {
    NavigationStack {
        ParamView(item: .example).environmentObject(Tint())
    }
}
