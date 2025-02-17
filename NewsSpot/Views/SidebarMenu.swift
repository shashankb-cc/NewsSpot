//
//  SidebarMenu.swift
//  NewsSpot
//
//  Created by Shashank B on 07/02/25.
//

import SwiftUI

struct SidebarMenu: View {
    @Binding var isSideBarOpen: Bool
    
    var body: some View {
        ZStack {
            ZStack {
//                Color.black.opacity(0.5)
//                    .ignoresSafeArea()

                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
            }
            .onTapGesture {
                withAnimation(.easeInOut) {
                    isSideBarOpen = false
                }
            }

            
            
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    HStack{
                        Text("Menu")
                        Spacer()
                        Button(action:{
                            isSideBarOpen=false
                        }){
                            Image(systemName:"chevron.left")
                        }
                    }
                    .font(.title2)
                    .bold()
                    .padding(.top)
                    .padding(.bottom)
                    
                    NavigationLink(destination: HomePage()) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                    }
                    .padding(.vertical,8)
                    
                    NavigationLink(destination: Text("Bookmarks View")) {
                        HStack {
                            Image(systemName: "bookmark.fill")
                            Text("Bookmarks")
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                    }
                    .padding(.vertical,8)
                    
                    NavigationLink(destination: Text("Settings View")) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                    }
                    .padding(.vertical,8)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height)
                .background(Color.white)
                .offset(x: isSideBarOpen ? 0 : -UIScreen.main.bounds.width * 0.6)
                
                Spacer()
            }
            .padding(.top)
        }
            .opacity(isSideBarOpen ? 1 : 0)
            .animation(.spring(), value: isSideBarOpen)
        
    }
}

#Preview{
    SidebarMenu(isSideBarOpen: .constant(true))
}
