//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct FilterButton: View {
    @Binding var levels: Set<EventLevel>

    @State private var isFilterPresented = false

    var body: some View {
        Button("Filter") {
            isFilterPresented = true
        }
        .sheet(isPresented: $isFilterPresented) {
            FilterView(selected: $levels).presentationDetents([.height(392)])
        }
        .tint(.blue)
    }
}

#Preview {
    FilterButton(levels: .constant(Set(EventLevel.allCases)))
}
