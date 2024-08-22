//
//  HomeDataModel.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import Foundation

struct HomeDataModel: Codable {
    var response: Response?
}

struct Response: Codable {
    var docs: [Docs]?
}

struct Docs: Codable {
    var abstract: String?
    var multimedia: [Multimedia]?
    var headline: Headline?
    var pubDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case abstract
        case multimedia
        case headline
        case pubDate = "pub_date"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        self.multimedia = try container.decodeIfPresent([Multimedia].self, forKey: .multimedia)
        self.headline = try container.decodeIfPresent(Headline.self, forKey: .headline)
        self.pubDate = try container.decodeIfPresent(String.self, forKey: .pubDate)
    }
    
}

struct Headline: Codable {
    var main: String?
}

struct Multimedia: Codable {
    var url: String?
}
