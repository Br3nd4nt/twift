//
//  TwitterServiceTests.swift
//  twift
//
//  Created by br3nd4nt on 17.01.2026.
//

@testable import twift
import Testing

@Suite("Twitter service tests")
struct TwitterServiceTests {
    @Test("Test basic request test")
    func helloWorld() async throws {
        let url = "x.com/NorthernIion_LP/status/2011775316587659682"
        let service = TwitterService()
        let result = try await service.getTweet(url)
        #expect(!result.text.isEmpty)
        print(result)
    }
}
