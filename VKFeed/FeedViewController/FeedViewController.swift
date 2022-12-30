//
//  FeedViewController.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 18.12.2022.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        fetcher.getFeed { (feedResponse) in
            guard let feedResponse = feedResponse else { return }
            
            feedResponse.items.map { (feedItem) in
                print(feedItem.text)
            }
        }
    }
    
}
