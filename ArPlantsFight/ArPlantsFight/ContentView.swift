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
        VStack{
            ArView(arViewModel: arViewModel)
            ScrollView(.horizontal){
                HStack{
                    Button(action: {arViewModel.selectedPlant = .BasicPlant}, label: {
                        Text("BasicPlant")
                    })
                    Button(action: {arViewModel.selectedPlant = .Sunflower}, label: {
                        Text("Sunflower")
                    })
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
