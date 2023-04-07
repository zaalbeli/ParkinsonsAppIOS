//
//  ContentView.swift
//  ParkinsonsAppIOS
//
//  Created by Zaal on 4/7/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        var n = 0
        
        VStack{
            Button("Click me", action: {
                n = n + 1
                print(n)
            })
          //  Text("Main Activity")
            }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}


//Image("trial").resizable().frame(width: 150.0, height: 150.0)//
