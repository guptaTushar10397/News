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

struct Docs: Codable, Equatable {
    var id: UUID = UUID()
    var abstract: String?
    var multimedia: [Multimedia]?
    var pubDate: String?
    var isFavourite: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case abstract
        case multimedia
        case pubDate = "pub_date"
    }
    
    init(id: UUID?, abstract: String?, multimedia: [Multimedia]?, pubDate: String?, isFavourite: Bool?) {
        self.id = id ?? UUID()
        self.abstract = abstract
        self.multimedia = multimedia
        self.pubDate = pubDate
        self.isFavourite = isFavourite ?? false
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        self.multimedia = try container.decodeIfPresent([Multimedia].self, forKey: .multimedia)
        self.pubDate = try container.decodeIfPresent(String.self, forKey: .pubDate)
    }
    
    static func == (lhs: Docs, rhs: Docs) -> Bool {
        lhs.id == rhs.id
    }
}

struct Multimedia: Codable {
    var url: String?
}
