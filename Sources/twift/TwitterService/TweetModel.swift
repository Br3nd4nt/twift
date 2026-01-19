//
//  TweetModel.swift
//  twift
//
//  Created by br3nd4nt on 17.01.2026.
//

struct Tweet: Decodable {
    let mediaURLs: [String]
    let media_extended: [MediaExtended]
    let text: String
    let user_name: String
    let user_profile_image_url: String
}

enum TwitterServiceErrors: Error {
    case invalidURL
}

struct MediaExtended: Decodable {
    let type: MediaType
    let url: String
}

enum MediaType: String, Decodable {
    case gif, video, image
}
