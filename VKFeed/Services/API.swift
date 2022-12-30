//
//  API.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 18.12.2022.
//

import Foundation

struct API {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let vesion = "5.131"
    
    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
