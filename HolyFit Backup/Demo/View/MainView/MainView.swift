//
//  MainView.swift
//  Demo
//
//  Created by Brennan Mahoney on 5/27/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        // TabViews With Recent Posts and Profile Tabs
        TabView{
            PostsView()
                .tabItem{
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Posts")
                }
            
            ProfileView()
                .tabItem{
                    Image(systemName: "gear")
                    Text("Profile")
                }
            
        }
        // Changing Tabl Label tint to black
        .tint(.black)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
