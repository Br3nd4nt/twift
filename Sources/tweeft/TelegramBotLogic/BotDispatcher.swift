//
//  BotDispatcher.swift
//  tweeft
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
        await add(TGBaseHandler(name: "InlineQueryHandler") { update in
            guard let inline = update.inlineQuery else { return }
            
            
            let q = inline.query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !q.isEmpty else {
                return
            }
            let textMessageContent = TGInputTextMessageContent(messageText: "You typed: \(q)")
            let messageContent = TGInputMessageContent.inputTextMessageContent(textMessageContent)
            
            let article = TGInlineQueryResultArticle(
                type: .article,
                id: UUID().uuidString,
                title: q.isEmpty ? "Default result": "Resault for: \(q)",
                inputMessageContent: messageContent,
                replyMarkup: nil,
                url: nil,
                description: nil,
                thumbnailUrl: nil,
                thumbnailWidth: nil,
                thumbnailHeight: nil
            )
            
            let articleQueryResult = TGInlineQueryResult.inlineQueryResultArticle(article)
            
            let results: [TGInlineQueryResult] = [articleQueryResult]
            
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
