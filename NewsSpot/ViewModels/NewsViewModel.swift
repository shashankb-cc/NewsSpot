//
//  NewsManagerModel.swift
//  NewsSpot
//
//  Created by Shashank B on 30/01/25.
//

import Foundation
import RealmSwift


class NewsManagerModel {
    let apikey = ""
    let baseUrl =  "https://newsapi.org/v2/top-headlines?country=us"
    
    func fetchNews() async throws -> [NewsArticle] {
        guard let url = URL(string: "\(baseUrl)&apiKey=\(apikey)") else {
            throw URLError(.badURL)
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
        
        return newsResponse.articles
    }
}


@MainActor
class NewsViewModel:ObservableObject {
    @Published var articles:[NewsArticle] = []
    private let newsManager = NewsManagerModel()
    
    func loadNews() async {
        
        do {
            articles = try await newsManager.fetchNews()
        } catch {
            print("erro")
            print("Error fetching the news \n \(error)")
        }
    }
}

class RealmCheckManager:ObservableObject {
    static let shared = RealmCheckManager()

    let realm: Realm?

     init() {
        do {
            Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
            realm = try Realm()
            print("✅ Realm initialized successfully")
        } catch {
            print("❌ Error initializing Realm: \(error.localizedDescription)")
            realm = nil
        }
    }
}
