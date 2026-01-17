//
//  TelegramController.swift
//  twift
//
//  Created by br3nd4nt on 16.01.2026.
//

import Vapor
import SwiftTelegramBot

final class TelegramController: RouteCollection, @unchecked Sendable {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.post("telegramWebHook", use: telegramWebHook)
    }
}

extension TelegramController {

    func telegramWebHook(_ req: Request) async throws -> Bool {
        let update: TGUpdate = try req.content.decode(TGUpdate.self)
        await app.bot.processing(updates: [update])
        return true
    }
}
