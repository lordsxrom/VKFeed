//
//  NetworkDataFetcher.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 18.12.2022.
//

import Foundation

protocol DataFetcher {
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    private let networking: Networking
    private let authService: AuthService
    
    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getFeed(nextBatchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post, photo"]
        params["start_from"] = nextBatchFrom
        networking.request(path: API.newsFeed, params: params) {(data, error) in
            if let error = error {
                print("Error recieving data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJson(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        
        let params = ["fields": "photo_100", "user_ids": userId]
        networking.request(path: API.user, params: params) {(data, error) in
            if let error = error {
                print("Error recieving data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJson(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    private func decodeJson<T: Decodable>(type: T.Type, from: Data?) -> T? {
        guard let data = from else { return nil }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let response = try? decoder.decode(type.self, from: data) else { return nil }
        
        return response
    }
    
}
