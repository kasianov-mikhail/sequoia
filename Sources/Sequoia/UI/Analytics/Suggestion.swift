//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct Suggestion: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 17))
                .monospaced()
                .searchCompletion(text)
                .foregroundStyle(.blue)
            Spacer()
        }
        .alignmentGuide(.listRowSeparatorTrailing) { dimension in
            dimension[.trailing]
        }
    }
}

#Preview {
    List {
        Suggestion(text: "Suggestion")
    }
    .listStyle(.plain)
}
