//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var selected: Set<EventLevel>

    @State private var cache: Set<EventLevel> = []
    @State private var apply = false

    var body: some View {
        NavigationView {
            List(EventLevel.allCases, id: \.rawValue) { level in
                HStack {
                    Image(systemName: "circle.fill")
                        .imageScale(.medium)
                        .foregroundStyle(level.color ?? .blue)
                        .opacity(cache.contains(level) ? 1 : 0)
                    Text(level.description)
                        .font(.system(size: 16))
                    Spacer()
                }
                .contentShape(Rectangle())
                .alignmentGuide(.listRowSeparatorTrailing) { dimension in
                    dimension[.trailing]
                }
                .onTapGesture {
                    cache.toggle(level)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Reset") {
                        cache = Set(EventLevel.allCases)
                    }
                    .disabled(cache == Set(EventLevel.allCases))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        apply = true
                        dismiss()
                    }
                    .disabled(cache.isEmpty)
                    .disabled(cache == selected)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                cache = selected
            }
            .onDisappear {
                if apply {
                    selected = cache
                }
            }
            .padding(.top)
            .listStyle(.plain)
            .scrollDisabled(true)
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension Set {
    fileprivate mutating func toggle(_ element: Element) {
        if !contains(element) {
            insert(element)
        } else {
            remove(element)
        }
    }
}

#Preview {
    FilterView(selected: .constant(Set(EventLevel.allCases)))
}
