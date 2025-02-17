//
//  NewsCard.swift
//  NewsSpot
//
//  Created by Shashank B on 30/01/25.
//

import SwiftUI

struct NewsCardView: View {
    let article: NewsArticle
    
    @State private var offset: CGFloat = 0
    @State private var showDeleteAlert = false
    
    //decides how much the card shoukd move when swiped
    private let swipeThreshold: CGFloat = -100
//    @StateObject private var realmviewManager = RealmNewsViewManager()
    @EnvironmentObject private var realmviewManager:RealmNewsManager
    
    var body: some View {
        let cardWidth = UIScreen.main.bounds.width * 0.9
        let imageHeight = cardWidth * 0.6
        
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: cardWidth, height: imageHeight)
            .clipped()
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: 16,
                topTrailingRadius: 16
            ))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(article.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text(article.description ?? "No description available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                VStack {
                    HStack {
                        Text("Source:")
                        Spacer()
                        Text("Published at:")
                    }
                    .fontWeight(.bold)
                    HStack {
                        Text(article.sourceName ?? "Anonymous")
                        Spacer()
                        Text("\(formatDate(article.publishedAt))")
                    }
                }
                .font(.footnote)
                .foregroundStyle(.gray)
            }
            .padding()
        }
        .frame(width: cardWidth)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .offset(x: offset)
        .gesture(
            DragGesture()
                .onChanged({ gesture in
                    if gesture.translation.width < 0 {  // Swipe left
                        withAnimation(.interactiveSpring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.2)) {
                            offset = gesture.translation.width
                        }
                        
                    }
                })
                .onEnded({ gesture in
                    if gesture.translation.width < swipeThreshold {
                    // Trigger alert if swiped past threshold
                        showDeleteAlert = true
                        withAnimation(.spring()) {
                            offset = swipeThreshold // Keep in position for alert
                        }
                    } else {
                        // Bounce back
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                })
        )
        .alert("Delete Article?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    offset = 0  
                }
            }
            Button("Delete", role: .destructive) {
                Task {
                    realmviewManager.deleteArticle(article)
                }
            }
        } message: {
            Text("Are you sure you want to delete this article?")
        }
            
    }
}

func formatDate(_ dateString: String) -> String {
    let formatter = ISO8601DateFormatter()
    if let date = formatter.date(from: dateString) {
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
    return "Unknown Date"
}
//#Preview {
//    NewsCardView(article: NewsArticle.sample )
//}
