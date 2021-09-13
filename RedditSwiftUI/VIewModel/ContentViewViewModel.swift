//
//  ContentViewViewModel.swift
//  RedditSwiftUI
//
//  Created by Julio Reyes on 8/27/21.
//

import Foundation
import SwiftUI
import Combine

class ContentViewViewModel: ObservableObject {
    
    @Published var feedAPIData = FeedDataSource()
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var initialURLString = "http://www.reddit.com/.json"
    private var nextURLString = "http://www.reddit.com/.json?after="
    private var afterLinkString: String?
    
    @Published var fullAPIData: APIData? = nil
    
    init() {
        loadContentWithURL(urlString: initialURLString)
    }
    
    private func loadContentWithURL(urlString: String) {
        guard !isLoadingPage else {
          return
        }

        isLoadingPage = true
        
        let url = URL(string: urlString)
        URLSession.shared.dataTaskPublisher(for: url!)
            .map(\.data)
            .decode(type: APIData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                    self.isLoadingPage = false
                    self.currentPage += 1
                  })
            .map({ response in
                return self.fullAPIData
            })
            .catch({ _ in Just(self.fullAPIData) })
            .assign(to: &$fullAPIData)
        
        DispatchQueue.main.async {
            for feed in self.fullAPIData!.data.feeds {
                self.feedAPIData.append(feed.feeddata)
            }
        }
    }
    
    func loadMoreContentAfter(currentFeed feed: FeedData?) {
        // Initial case
        guard let afterLink = fullAPIData?.data.afterLink else { return  }
        guard let feed = feed else {
            loadContentWithURL(urlString: initialURLString)
            return
        }
        
        let thresholdIndex = feedAPIData.index(feedAPIData.endIndex, offsetBy: -5)
        if feedAPIData.firstIndex(where: { $0.feedID == feed.feedID }) == thresholdIndex {
            loadContentWithURL(urlString: nextURLString + afterLink)
        }
        
    }
    
}
