//
//  ArticleModel.swift
//  NewsSpot
//
//  Created by Shashank B on 30/01/25.
//

import Foundation
import RealmSwift

struct NewsArticle: Codable, Identifiable {
    var id : String{url}
    let sourceName: String?
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
//swifUI

struct NewsSource: Codable {
    let id: String?
    let name: String
}

struct NewsResponse:Codable {
    let articles:[NewsArticle]
}

//extension NewsArticle {
//    static let sample = NewsArticle(
//        source: NewsSource(id: nil, name: "WFMZ Allentown"),
//        author: nil,
//        title: "50K chickens being put to death because of bird flu in Lehigh County - 69News WFMZ-TV",
//        description: "The PA Department of Agriculture announced Monday that the state's first case of bird flu found in a commercial flock at a Lynn Township facility.",
//        url: "https://www.wfmz.com/news/area/lehighvalley/50k-chickens-being-put-to-death-because-of-bird-flu-in-lehigh-county/article_23891f32-ddce-11ef-9d9b-6f72c0e64fa1.html",
//        urlToImage: "https://bloximages.newyork1.vip.townnews.com/wfmz.com/content/tncms/assets/v3/editorial/1/50/150da16e-796d-5c05-9ed3-b03cba612141/679968b43c2fd.image.jpg?crop=1280%2C672%2C0%2C23&resize=1200%2C630&order=crop%2Cresize",
//        publishedAt: "2025-01-28T23:18:00Z",
//        content: "Bulletin: ...WIND ADVISORY IN EFFECT FROM 9 AM TO 6 PM EST WEDNESDAY... Indigo CEO Pieter Elbers visited the Mahakumbh Mela in Prayagraj over the weekend, joining millions of people who are at the world’s largest religious festival. Mahakumbh 2025 is particularly special because it is occurring after 144 years under a rare and highly auspicious astrological alignment. The last such occurrence was in 1881, making the 2025 Mahakumbh a once-in-a-lifetime event for devotees and saints. Indigo CEO Pieter Elbers visited the Mahakumbh Mela in Prayagraj over the weekend, joining millions of people who are at the world’s largest religious festival. Mahakumbh 2025 is particularly special because it is occurring after 144 years under a rare and highly auspicious astrological alignment. The last such occurrence was in 1881, making the 2025 Mahakumbh a once-in-a-lifetime event for devotees and saints. Indigo CEO Pieter Elbers visited the Mahakumbh Mela in Prayagraj over the weekend, joining millions of people who are at the world’s largest religious festival. Mahakumbh 2025 is particularly special because it is occurring after 144 years under a rare and highly auspicious astrological alignment. The last such occurrence was in 1881, making the 2025 Mahakumbh a once-in-a-lifetime event for devotees and saints. Indigo CEO Pieter Elbers visited the Mahakumbh Mela in Prayagraj over the weekend, joining millions of people who are at the world’s largest religious festival. Mahakumbh 2025 is particularly special because it is occurring after 144 years under a rare and highly auspicious astrological alignment. The last such occurrence was in 1881, making the 2025 Mahakumbh a once-in-a-lifetime event for devotees and saints. Indigo CEO Pieter Elbers visited the Mahakumbh Mela in Prayagraj over the weekend, joining millions of people who are at the world’s largest religious festival. Mahakumbh 2025 is particularly special because it is occurring after 144 years under a rare and highly auspicious astrological alignment. The last such occurrence was in 1881, making the 2025 Mahakumbh a once-in-a-lifetime event for devotees and saints. "
//    )
//}



class RealmNewsArticle:Object,Identifiable {
    @Persisted(primaryKey: true) var id:String
    @Persisted var sourceName: String?
    @Persisted var author: String?
    @Persisted var title: String
    @Persisted var descriptions: String?
    @Persisted var url: String
    @Persisted var urlToImage: String?
    @Persisted var publishedAt: String
    @Persisted var content: String?
    
    convenience init(from article: NewsArticle) {
        self.init()
        self.id = article.url
        self.sourceName = article.sourceName
        self.author = article.author
        self.title = article.title
        self.descriptions = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
    
}

////Realm
//class RealNewsSource:EmbeddedObject{
//    @Persisted var id: String?
//    @Persisted var name: String
//}
////
////
////
//class RealNewsResponse {
//    @Persisted var articles:List<RealmNewsArticle>
//}





extension RealmNewsArticle {
    static let sample: RealmNewsArticle = {
        let article = RealmNewsArticle()
        article.id = "www.gmail.com"
        
      
        article.sourceName = "CZZ News"
        
        article.author = nil
        article.title = "50K chickens being put to death because of bird flu in Lehigh County - 69News WFMZ-TV"
        article.descriptions = "The PA Department of Agriculture announced Monday that the state's first case of bird flu found in a commercial flock at a Lynn Township facility."
        article.url = "https://www.wfmz.com/news/area/lehighvalley/50k-chickens-being-put-to-death-because-of-bird-flu-in-lehigh-county/article_23891f32-ddce-11ef-9d9b-6f72c0e64fa1.html"
        article.urlToImage = "https://bloximages.newyork1.vip.townnews.com/wfmz.com/content/tncms/assets/v3/editorial/1/50/150da16e-796d-5c05-9ed3-b03cba612141/679968b43c2fd.image.jpg?crop=1280%2C672%2C0%2C23&resize=1200%2C630&order=crop%2Cresize"
        article.publishedAt = "2025-01-28T23:18:00Z"
        article.content = """
        Bulletin: ...WIND ADVISORY IN EFFECT FROM 9 AM TO 6 PM EST WEDNESDAY...
        Indigo CEO Pieter Elbers visited the Mahakumbh Mela in Prayagraj over the weekend, joining millions of people who are at the world’s largest religious festival.
        Mahakumbh 2025 is particularly special because it is occurring after 144 years under a rare and highly auspicious astrological alignment.
        The last such occurrence was in 1881, making the 2025 Mahakumbh a once-in-a-lifetime event for devotees and saints.
        """
        
        return article
    }()
}
