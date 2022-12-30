//
//  NetworkService.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 18.12.2022.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String],  completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService {
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func createDataTask(
        from request: URLRequest,
        completion: @escaping (Data?, Error?) -> Void
    ) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url!
    }
    
}

// MARK: Networking

extension NetworkService: Networking {
    
    func request(path: String, params: [String : String],  completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        
        let params = params
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.vesion
        let url = self.url(from: path, params: allParams)
        
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
}
