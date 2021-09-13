//
//  RedditAPIData.swift
//  RedditSwiftUI
//
//  Created by Julio Reyes on 8/27/21.
//

import Foundation



enum RedditAPI {
    
}

typealias FeedDataSource = [FeedData]


struct APIData: Codable {
    let data: Feeds
}

struct Feeds: Codable {
    let feeds: [Feed]
    let afterLink: String

    enum CodingKeys: String, CodingKey {
        case afterLink = "after"
        case feeds = "children"
    }
}

struct Feed: Codable {
    let feeddata: FeedData
    
    enum CodingKeys: String, CodingKey {
        case feeddata = "data"
    }
}

struct FeedData: Codable, Hashable {
    
    let feedID: UUID
    let title: String
    let comments: Int
    let thumbnailLink: String?
    let thumbnailHeight: Int?
    let thumbnailWidth: Int?
    let score: Int
    let linkurl: String
    
    enum CodingKeys: String, CodingKey {
        case feedID
        case title
        case comments        = "num_comments"
        case thumbnailLink   = "thumbnail"
        case thumbnailHeight = "thumbnail_height"
        case thumbnailWidth  = "thumbnail_width"
        case score = "score"
        case linkurl = "url"
    }
}
