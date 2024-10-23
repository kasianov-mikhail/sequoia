//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CloudKit
import SwiftUI

@available(iOS 17.0, *)
struct EventRow: View {
    let event: Event
    let timeline: Date

    let dateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                Text(event.name)
                    .font(.system(size: 17))
                    .lineLimit(1)
                    .monospaced()

                Spacer()

                if let date = event.date {
                    TimelineView(.periodic(from: timeline, by: 1)) { _ in
                        if date.timeIntervalSinceNow < -60 {
                            Text(dateFormatter.localizedString(for: date, relativeTo: Date()))
                        } else {
                            Text("recently")
                        }
                    }
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray)
                }
            }

            NavigationLink {
                EventView(event: event, showHistory: true)
            } label: {
                EmptyView()
            }
            .opacity(0)
        }
        .listRowBackground(event.level?.color?.opacity(0.1) ?? .white)
        .alignmentGuide(.listRowSeparatorTrailing) { dimension in
            dimension[.trailing]
        }
    }
}

#Preview {
    if #available(iOS 17.0, *) {
        EventRow(event: .example(), timeline: Date())
    }
}
