//
//  HomePage.swift
//  NewsSpot
//
//  Created by Shashank B on 30/01/25.
//

import SwiftUI
import RealmSwift


struct HomePage: View {
    @StateObject private var viewModel = NewsViewModel()
    @State private var isSidebarVisible = false
    @StateObject private var realmviewManager = RealmNewsManager()
    
    //search functionlaity
    @State private var searchText = ""
    @State private var isSearching = false 
    
    
    //side bar
    @State var isSideBarOpen: Bool = false
    
    var filteredArticles: [NewsArticle] {
        if searchText.isEmpty {
            return realmviewManager.articles
        } else {
            return realmviewManager.articles.filter {
                ($0.title.localizedCaseInsensitiveContains(searchText) ||
                 $0.author?.localizedCaseInsensitiveContains(searchText) ?? false ||
                 $0.sourceName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }


    var body: some View {
        VStack {
            HStack(spacing:15)  {
                VStack (alignment:.leading) {
                    Text("NewSpot")
                        .fontWeight(.bold)
                    Text("Stay updated to current world")
                        .font(.subheadline)
                }
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isSearching.toggle()
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                }
                Button(action: {
                    withAnimation {
                        isSideBarOpen.toggle()
                    }
                }) {
                    Image(systemName: "line.3.horizontal")
                }
            }
            .padding(.horizontal)
            .padding(.vertical,5)
            .background(
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                
            )
            .font(.title)
            Divider()
            
            
            
            NavigationStack {
                if isSearching {
                    HStack {
                        TextField("Search...", text: $searchText)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.gray.opacity(0.3))
                            )
                            .frame(maxWidth: .infinity)
                            .transition(.move(edge: .trailing))
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                withAnimation {
                                    searchText = ""
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 25,height: 25)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    .padding([.leading,.trailing])
                }
                
                ScrollView {
                    if filteredArticles.isEmpty {
                        Text("No articles found")
                    } else {
                        LazyVStack(spacing: 30) {
                            ForEach(filteredArticles) { article in
                                NavigationLink(destination:
                                                NewsDetailView(article: article)
                                    .padding(.horizontal,30)                                                  .frame(maxHeight:.infinity)
                                ) {
                                    NewsCardView(article: article)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                .onAppear {
                                    if article.id == filteredArticles.last?.id {
                                        realmviewManager.loadMoreContent()
                                    }
                                }
                            }
                            if realmviewManager.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding()
                    }
                }
                .refreshable {
                    await realmviewManager.fetchNews()
                }
                .overlay(SidebarMenu(isSideBarOpen: $isSideBarOpen))
                
            }
            
            
            .task {
                realmviewManager.fetchStoredNews()
            }
            .environmentObject(realmviewManager)
            
        }
        
        .ignoresSafeArea(edges:.bottom)
    }
        
    
}


#Preview {
    HomePage()
}
