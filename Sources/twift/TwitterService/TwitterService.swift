//
//  TwitterService.swift
//  twift
//
//  Created by br3nd4nt on 17.01.2026.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class TwitterService {
    private static let jsonDecoder = JSONDecoder()
    
    func getTweet(_ urlString: String) async throws -> Tweet {
        guard let url = URL(string: prepareURL(urlString)) else {
            throw TwitterServiceErrors.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse,
              200 ..< 300 ~= http.statusCode
        else {
            throw URLError(.badServerResponse)
        }
        let tweet = try Self.jsonDecoder.decode(Tweet.self, from: data)
        
        return tweet
    }
    
    func prepareURL(_ url: String) -> String {
        var replaced = url
            .replace("x.com", "twitter.com")
            .replace("twitter.com", "api.vxtwitter.com")
            .replace("http://", "https://")
        if !replaced.hasPrefix("https://") {
            replaced = "https://" + replaced
        }
        return replaced
    }
}
