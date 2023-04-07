//
//  ContentView.swift
//  ParkinsonsAppIOS
//
//  Created by Zaal on 4/7/23.
//

import SwiftUI
import Foundation

struct FirstView: View {
    var body: some View {
        NavigationView{
            VStack{
            MainView()
                .navigationTitle("Main View")
                .offset(y:-200)
                
                
                NavigationLink(destination: SecondView(), label:{Text("yes")})
                
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
            VStack{
            MainView()
                .navigationTitle("Next View")
                .offset(y:-200)
                
                NavigationLink(destination: Text("d"), label:{Text("yes")})
                
            }
    }
}
struct MainView: View{
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
        FirstView()
            
    }
}


//Image("trial").resizable().frame(width: 150.0, height: 150.0)//
