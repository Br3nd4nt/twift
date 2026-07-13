//
//  BotDispatcher.swift
//  twift
//
//  Created by br3nd4nt on 16.01.2026.
//

import Vapor
import SwiftTelegramBot

final class BotDispatcher: TGDefaultDispatcher, @unchecked Sendable {
    
    override
    func handle() async {
        await commandPingHandler()
        await inlineHandler()
    }
    
    private func defaultBaseHandler() async {
        await add(TGBaseHandler({ update in
            guard let message = update.message else { return }
            let params: TGSendMessageParams = .init(chatId: .chat(message.chat.id), text: "TGBaseHandler")
            try await self.bot.sendMessage(params: params)
        }))
    }
    
    private func messageHandler() async {
        await add(TGMessageHandler(filters: (.all && !.command.names(["/ping"]))) { update in
            let params: TGSendMessageParams = .init(chatId: .chat(update.message!.chat.id), text: "Success")
            try await self.bot.sendMessage(params: params)
        })
    }
    
    private func commandPingHandler() async {
        await add(TGCommandHandler(commands: ["/ping"]) { update in
            try await update.message?.reply(text: "pong", bot: self.bot)
        })
    }
    
    private func inlineHandler() async {
        await add(
            TGBaseHandler(name: "InlineQueryHandler") { update in
                guard let inline = update.inlineQuery else { return }
                let trimmed = inline.query.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    return
                }
                let tweet: Tweet
                do {
                    tweet = try await TwitterService().getTweet(trimmed)
                } catch {
                    return
                }
                let text = """
                \(tweet.text)
                <a></a>
                <a href="\(trimmed)">\(tweet.user_name)</a> - @TwiftBot
                """
                guard let media = tweet.media_extended.first else {
                    let message = TGInputMessageContent.inputTextMessageContent(
                        TGInputTextMessageContent(messageText: text, parseMode: "html")
                    )
                    let params = TGAnswerInlineQueryParams(
                        inlineQueryId: inline.id,
                        
                        results: [.inlineQueryResultArticle(
                            TGInlineQueryResultArticle(
                                type: .article,
                                id: UUID().uuidString,
                                title: "Tweet",
                                inputMessageContent: message,
                            )
                        )],
                        cacheTime: 60,
                        isPersonal: true,
                        nextOffset: ""
                    )
                    try await self.bot.answerInlineQuery(params: params)
                    return
                }
                let results: [TGInlineQueryResult]
                self.log.debug("media type: \(media.type)")
                switch media.type {
                case .gif:
                    let gif = TGInlineQueryResultGif(
                        type: .gif,
                        id: UUID().uuidString,
                        gifUrl: media.url,
                        thumbnailUrl: tweet.user_profile_image_url,
                        title: "Tweet",
                        caption: text,
                        parseMode: "html",
                        showCaptionAboveMedia: true
                    )
                    
                    results = [.inlineQueryResultGif(gif)]
                case .video:
                    let video = TGInlineQueryResultVideo(
                        type: .video,
                        id: UUID().uuidString,
                        videoUrl: media.url,
                        mimeType: "video/mp4",
                        thumbnailUrl: tweet.user_profile_image_url,
                        title: "Tweet",
                        caption: text,
                        parseMode: "html",
                        showCaptionAboveMedia: true
                    )
                    results = [.inlineQueryResultVideo(video)]
                case .image:
                    let image = TGInlineQueryResultPhoto(
                        type: .photo,
                        id: UUID().uuidString,
                        photoUrl: media.url,
                        thumbnailUrl: media.url,
                        title: "Tweet",
                        caption: text,
                        parseMode: "html",
                        showCaptionAboveMedia: true
                    )
                    results = [.inlineQueryResultPhoto(image)]
                }
                let params = TGAnswerInlineQueryParams(
                    inlineQueryId: inline.id,
                    results: results,
                    cacheTime: 60,
                    isPersonal: true,
                    nextOffset: ""
                )
                try await self.bot.answerInlineQuery(params: params)
            })
    }
}

