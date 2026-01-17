//
//  TweetModel.swift
//  twift
//
//  Created by br3nd4nt on 17.01.2026.
//

struct Tweet: Decodable {
    let mediaURLs: [String]
    let text: String
    let user_name: String
    let user_profile_image_url: String
}

enum TwitterServiceErrors: Error {
    case invalidURL
}
