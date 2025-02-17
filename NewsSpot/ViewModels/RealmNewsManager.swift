////
////  RealmNewsManager.swift
////  NewsSpot
////
////  Created by Shashank B on 07/02/25.
////
//
//import Foundation
//import RealmSwift
//
//@MainActor
//class RealmNewsManager:ObservableObject {
//  
//    let apikey = ""
//    let baseUrl = "https://newsapi.org/v2/top-headlines?country=us"
//    private var realm: Realm
//    
//    init() {
//        do {
//            realm = try! Realm()
//        
//        }
//    }
//        
//        func fetchNews() async throws {
//            guard let url = URL(string: "\(baseUrl)&apiKey=\(apikey)") else {
//                throw URLError(.badURL)
//            }
//            
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
//            
//            let realmArticles = newsResponse.articles.map { article in
//                let realmArticle = RealmNewsArticle()
//                realmArticle.id = article.url
//                realmArticle.sourceName = article.source?.name
//                realmArticle.author = article.author
//                realmArticle.title = article.title
//                realmArticle.descriptions = article.description
//                realmArticle.url = article.url
//                realmArticle.urlToImage = article.urlToImage
//                realmArticle.publishedAt = article.publishedAt
//                realmArticle.content = article.content
//                return realmArticle
//            }
//            
//            
//            
//            
//            
//            do {
//                try realm.write {
//                    realm.delete(realm.objects(RealmNewsArticle.self))
//                    realm.add(realmArticles)
//                }
//            } catch {
//                print("❌ Error writing to Realm: \(error)")
//            }
//            
//        }
//        
//        
//        // Fetches stored news from Realm
//        func getStoredNews() -> [RealmNewsArticle] {
//            print(Array(realm.objects(RealmNewsArticle.self)))
//            return Array(realm.objects(RealmNewsArticle.self))
//        }
//        
//        func deleteArticle(withId articleId: String) async throws {
//    
//            do {
//                        
//            if let objectToDelete = realm.object(ofType: RealmNewsArticle.self, forPrimaryKey: articleId) {
//                try realm.write {
//                    realm.delete(objectToDelete)
//                    print("✅ Article deleted from Realm")
//                }
//            } else {
//                print("⚠️ Article not found in Realm")
//                }
//            } catch {
//                print("❌ Error writing to Realm: \(error)")
//                }
//    }
//}
//
//
//@MainActor  //this is because the class which updates the UI must always be the main thread
//class RealmNewsViewManager: ObservableObject {
//    @Published var articles: [RealmNewsArticle] = []
//    private let newsManager = RealmNewsManager()
//    
//
//    /// Loads news from API and updates Realm storage
//    func loadNews() async {
//        do {
//            
//            let _ = try await newsManager.fetchNews()
//            fetchStoredNews()
//        } catch {
//            print("Error fetching news: \(error)")
//        }
//    }
//
//    /// Loads news from Realm
//    func fetchStoredNews() {
//        articles = newsManager.getStoredNews()
//    }
//    
//    func deleteArticle(_ article: RealmNewsArticle) async throws {
//        do{
//            try await newsManager.deleteArticle(withId: article.id)
//            articles = newsManager.getStoredNews()
//            print(articles)
//        }catch{
//            print("Error \(error.localizedDescription)")
//        }
//    }
//}
//
//  RealmNewsManager.swift
//  NewsSpot
//
//  Created by Shashank B on 07/02/25.
//

import Foundation
import RealmSwift

@MainActor
class RealmNewsManager: ObservableObject {
    
    @Published var articles: [NewsArticle] = []
    @Published var isLoading:Bool = false
    
    private let apikey = ""
    private let baseUrl = "https://newsapi.org/v2/top-headlines?country=us"
    private var realm: Realm?
    
    
    //pagination
    @Published var currentPage: Int = 1
    private let pageSize: Int = 10

    init() {
        do {
            self.realm = try Realm()
//            fetchStoredNews()
        } catch {
            print("❌ Error initializing Realm: \(error)")
        }
    }

    func fetchStoredNews() {
            guard let realm = self.realm else { return }
            let allArticles = realm.objects(RealmNewsArticle.self)
            let endIndex = min(pageSize * currentPage, allArticles.count)
            articles = Array(allArticles.prefix(endIndex)).map { realmArticle in
                NewsArticle(
                    sourceName: realmArticle.sourceName,
                    author: realmArticle.author,
                    title: realmArticle.title,
                    description: realmArticle.descriptions,
                    url: realmArticle.url,
                    urlToImage: realmArticle.urlToImage,
                    publishedAt: realmArticle.publishedAt,
                    content: realmArticle.content
                )
            }
        }
        
    func loadMoreContent() {
            currentPage += 1
            fetchStoredNews()
    }

    // Fetches news from API and stores it in Realm
    func fetchNews() async {
        guard let url = URL(string: "\(baseUrl)&apiKey=\(apikey)&pageSize=100") else {
            print("❌ Invalid URL")
            return
        }
        
        do {
            isLoading = true
            let (data, _) = try await URLSession.shared.data(from: url)
            let newsResponse = try JSONDecoder().decode(NewsResponse.self, from: data)
            
            let realmArticles = convertToRealmArticles(from: newsResponse)

            guard let realm = self.realm else { return }
            try realm.write {
                realm.delete(realm.objects(RealmNewsArticle.self))
                realm.add(realmArticles)
            }
            isLoading = false
            currentPage = 1
            fetchStoredNews()
        } catch {
            print("❌ Error fetching news: \(error)") 
        }
    }

    

    /// Deletes an article by ID from Realm
    func deleteArticle(_ article: NewsArticle) {
        guard let realm = self.realm else { return }

        do {
            if let objectToDelete = realm.object(ofType: RealmNewsArticle.self, forPrimaryKey: article.id) {
                try realm.write {
                    realm.delete(objectToDelete)
                    print("✅ Article deleted from Realm")
                }
            } else {
                print("⚠️ Article not found in Realm")
            }
        } catch {
            print("❌ Error deleting from Realm: \(error)")
        }

        fetchStoredNews()
    }
    // Converts `NewsResponse` into an array of `RealmNewsArticle`
    func convertToRealmArticles(from newsResponse: NewsResponse) -> [RealmNewsArticle] {
        return newsResponse.articles.map { article in
            let realmArticle = RealmNewsArticle()
            realmArticle.id = article.url
            realmArticle.sourceName = article.sourceName
            realmArticle.author = article.author
            realmArticle.title = article.title
            realmArticle.descriptions = article.description
            realmArticle.url = article.url
            realmArticle.urlToImage = article.urlToImage
            realmArticle.publishedAt = article.publishedAt
            realmArticle.content = article.content
            return realmArticle
        }
    }

}
