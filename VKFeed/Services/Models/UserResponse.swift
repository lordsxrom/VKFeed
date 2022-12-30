//
//  UserResponse.swift
//  VKFeed
//
//  Created by Nikita Shumskii on 28.12.2022.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
