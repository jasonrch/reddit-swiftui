//
//  ContentView.swift
//  RedditSwiftUI
//
//  Created by Julio Reyes on 8/26/21.
//

import SwiftUI


struct ListViewCell: View {
    var feedData: FeedData
    var body: some View {
        Text(verbatim: feedData.title)
        CachedImageView(feedData.thumbnailLink ?? "")
        Spacer()
        HStack {
            Text(String(feedData.score))
            Spacer()
            Spacer()
            Text(String(feedData.comments))
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewViewModel
    
    
    var body: some View {
        List(viewModel.feedAPIData) { feed in
            ListViewCell(feedData: feed)
                .onAppear{
                    viewModel.loadMoreContentAfter(currentFeed: feed)
                }
                .padding(.all, 30)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
