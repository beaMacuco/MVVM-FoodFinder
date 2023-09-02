//
//  EmptyHandlerListView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 18/08/23.
//

import SwiftUI

struct EmptyHandlerListView<Content: View>: View {
    let isEmpty: Bool
    @Binding var shouldRefresh: Bool
    @ViewBuilder let content: Content
    
    var body: some View {
        if isEmpty {
            EmptyListView(shouldRefresh: $shouldRefresh)
        } else {
            content
        }
    }
}
