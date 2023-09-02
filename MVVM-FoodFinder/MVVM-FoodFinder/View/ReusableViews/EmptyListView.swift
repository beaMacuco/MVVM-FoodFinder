//
//  EmptyView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 17/08/23.
//

import SwiftUI

struct EmptyListView: View {
    @Binding var shouldRefresh: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: StaticViewValues.ViewSpacing.viewSpacing) {
            Text(StaticViewValues.LocalisableStrings.emptyView)
            
            Button {
                shouldRefresh.toggle()
            } label: {
                Text(StaticViewValues.LocalisableStrings.refresh)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}
