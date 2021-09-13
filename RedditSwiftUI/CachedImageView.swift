//
//  CachedImageView.swift
//  RedditSwiftUI
//
//  Created by Julio Reyes on 8/27/21.
//

import Foundation
import SwiftUI

struct CachedImageView: View {
    @ObservedObject var imgLoader: ImageCacheLoader
    init(_ imageurl: String) {
        imgLoader = ImageCacheLoader(imageURL: imageurl)
    }
    
    var body: some View {
        Image(uiImage: UIImage(data: self.imgLoader.imageData) ?? UIImage())
            .resizable()
            .clipped()
    }
}

class ImageCacheLoader: ObservableObject {
    @Published var imageData = Data()

    init(imageURL: String) {
        let cache = URLCache.shared
        let request = URLRequest(url: URL(string: imageURL)!, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let data = cache.cachedResponse(for: request)?.data {
            print("Image from Cache retreived")
            self.imageData = data
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response {
                let cachedData = CachedURLResponse(response: response, data: data)
                                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        print("Image Downloaded")
                        self.imageData = data
                    }
                }
            }).resume()
        }
    }
}
