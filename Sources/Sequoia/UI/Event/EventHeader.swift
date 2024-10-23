//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

@available(iOS 17.0, *)
struct EventHeader: View {
    let event: Event

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.y, HH:mm"
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            if let date = event.date {
                Text(dateFormatter.string(from: date))
                    .font(.system(size: 16))
                    .monospaced()
            }

            Spacer().frame(height: 10)

            if let level = event.level {
                Group {
                    Text("LEVEL:   ") +
                    Text(level.description.uppercased()).foregroundStyle(level.color ?? .blue)
                }
                .fontWeight(.bold)
            }
        }
        .padding(.vertical, 4)
    }
}

@available(iOS 17.0, *)
#Preview {
    List {
        EventHeader(event: .example())
    }
    .listStyle(.plain)
}
