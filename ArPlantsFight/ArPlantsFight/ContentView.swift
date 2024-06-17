//
//  ContentView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 17.06.24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State var arViewModel: ArViewModel = ArViewModel(width: 9, length: 5)
    
    var body: some View {
        HStack{
            VStack{
                Button(action: {arViewModel.toggleArMode()}, label: {
                    Text("ToggleAr")
                })
            }
            
            if (arViewModel.arMode == .AR) {
                ArView(arViewModel: arViewModel)
            } else {
                NonArView(arViewModel: arViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
