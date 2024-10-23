//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct ParamRow: View {
    let item: ParamItem?

    var body: some View {
        ZStack {
            HStack {
                if let key = item?.key {
                    Text(key).foregroundStyle(.secondary)
                } else {
                    Redacted(length: 8).opacity(0.5)
                }

                Spacer()

                if let value = item?.value {
                    Text(value).monospaced().font(.system(size: 16))
                } else {
                    Redacted(length: 8).opacity(0.5)
                }
            }

            if let item {
                NavigationLink {
                    ParamView(item: item)
                } label: {
                    EmptyView()
                }
                .opacity(0)
            }
        }
        .lineLimit(1)
        .alignmentGuide(.listRowSeparatorTrailing) { dimension in
            dimension[.trailing]
        }
    }
}

#Preview {
    List {
        ParamRow(item: .example)
    }
    .listStyle(.plain)
}

#Preview("Loading") {
    List {
        ParamRow(item: nil)
    }
    .listStyle(.plain)
}
