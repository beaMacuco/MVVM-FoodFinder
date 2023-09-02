//
//  FitWidthImageView.swift
//  MVVM-FoodFinder
//
//  Created by Beatriz Loures Macuco on 18/08/23.
//

import SwiftUI

struct FitWidthImageView: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
