//
//  LevelView.swift
//  ArPlantsFight
//
//  Created by Ramona Eckert on 09.07.24.
//

import SwiftUI

struct LevelView: View {
    @State private var currentLevel: Int = UserDefaults.standard.integer(forKey: "currentLevel")
    private let totalLevels = 5
    
    init() {
        if !UserDefaults.standard.bool(forKey: "isInitialized") {
            UserDefaults.standard.set(1, forKey: "currentLevel")
            UserDefaults.standard.set(true, forKey: "isInitialized")
        }
        currentLevel = UserDefaults.standard.integer(forKey: "currentLevel")
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Select Level")
                    .font(.largeTitle)
                    .padding()

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 20) {
                    ForEach(1...totalLevels, id: \.self) { level in
                        if level <= currentLevel {
                            NavigationLink(destination: ContentView()) {
                                Text("LVL \(level)")
                                    .font(.title)
                                    .frame(width: 100, height: 100)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                        } else {
                            Image(systemName: "lock.fill")
                                .font(.title)
                                .frame(width: 100, height: 100)
                                .background(Color.gray)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding()
            }
        }
    }
}


func saveCurrentLevel(level: Int) {
    UserDefaults.standard.set(level, forKey: "currentLevel")
}

func getCurrentLevel() -> Int {
    return UserDefaults.standard.integer(forKey: "currentLevel")
}

#Preview {
    LevelView()
}
