//
//  ContentView.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var appState: AppState
    @State var day =
    Helpers.dateToString(Date())
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(appState.habits) { habit in
                        HStack(alignment: .center, spacing: 2) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(habit.title).lineLimit(5)
                                Text(habit.description).lineLimit(5)
                            }
                            Spacer()
                            Image(systemName: habit.achievedOn.contains(day) ? "circle.fill" : "circle.dotted").frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        if habit.achievedOn.contains(day) {
                                            habit.achievedOn.remove(day)
                                        } else {
                                            habit.achievedOn.insert(day)
                                        }
                                    }
                                }
                        }.padding(4)
                    }
                    Spacer()
                }
                .padding(12)
            }.navigationBarTitle(day)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView(appState: AppState())
    }
}
