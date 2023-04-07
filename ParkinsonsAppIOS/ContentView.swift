//
//  ContentView.swift
//  ParkinsonsAppIOS
//
//  Created by Zaal on 4/7/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Image("trial")
                .cornerRadius(20)
                Text("Main Activity")
            }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
