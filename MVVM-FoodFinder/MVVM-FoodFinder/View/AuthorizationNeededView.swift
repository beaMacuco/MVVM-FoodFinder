//
//  AuthorizationNeededView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 16/08/23.
//

import SwiftUI

struct AuthorizationNeededView: View {
    private let settingsUrl = UIApplication.settingsUrl
    
    var body: some View {
        VStack(alignment: .leading, spacing: StaticViewValues.ViewSpacing.largeVerticalView) {
            Text(StaticViewValues.LocalisableStrings.greeting)
            Text(StaticViewValues.LocalisableStrings.authorizationNeededMessage)
                .font(.callout)
                .foregroundStyle(.gray)
            
            if let settingsUrl =  settingsUrl {
                Link(StaticViewValues.LocalisableStrings.goToSettings, destination: settingsUrl)
                    .foregroundStyle(.blue)
            }
        }
        .padding()
    }
}
