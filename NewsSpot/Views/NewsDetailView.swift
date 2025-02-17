//
//  NewsDetailView.swift
//  NewsSpot
//
//  Created by Shashank B on 30/01/25.
//

import SwiftUI

struct NewsDetailView: View {
    let article:NewsArticle
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        let cardWidth = UIScreen.main.bounds.width * 0.95
        let imageHeight = cardWidth * 0.6
        ScrollView {
            VStack() {
                
                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                HStack{
                    Image("default_author")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                    VStack(alignment: .leading, spacing: 5) {
                        Text((article.author?.isEmpty == false) ? article.author! : "Anonymous")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text(extractDate(from: article.publishedAt))
                            .foregroundStyle(.gray)
                    }
                    Spacer()
                    Text("World")
                        .padding(10)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .fontWeight(.bold)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                
                        )
                        .padding()
                }
                
                
                VStack (spacing:20) {
                    AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width:cardWidth, height: imageHeight)
                    .clipped()
                    .clipShape(.rect(
                        cornerRadius: 16
                    ))
                    
                    
                    VStack (alignment:.leading) {
                        Text(article.description ?? "")
                            .multilineTextAlignment(.leading)
                           
                        Text(article.content ?? "No Content Available for this news at the moment")
                        
                        if let url = URL(string: article.url) {
                            Link("Read more on this topic on internet ...", destination: url)
                                .font(.callout)
                                .padding(.top,5)
                        }
                           
                    }
                    
                }
                Spacer()
                Spacer()
                HStack {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "hand.thumbsup")
                            Text("Like")
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "hand.thumbsdown")
                            Text("Dislike")
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "message")
                            Text("Comment")
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                    }
                }
                
                .font(.subheadline)
                .fontWeight(.semibold)
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
          
            
        }
        .navigationBarBackButtonHidden()
        .gesture(
            DragGesture().onEnded({ gesture in
                let _ = gesture.translation.width //right and left translation +ve means right to left
                let _ = gesture.translation.height // top and bottom
                if gesture.translation.width > 100 {
                    dismiss()
                }
                if gesture.translation.width < -100 { 
                    dismiss()
                }
            })
        )
    }
    func extractDate(from dateTime: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        if let date = formatter.date(from: dateTime) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        }
        
        return "Invalid Date"
    }

}

//#Preview {
//    NewsDetailView(article: NewsArticle.sample)
//}
