import Vapor
import SwiftTelegramBot
import Foundation

public func configure(_ app: Application) async throws {
        guard let tgApi = ProcessInfo.processInfo.environment["TELEGRAM_BOT_TOKEN"] else {
            print("TELEGRAM_BOT_TOKEN variable wasn't found in enviroment variables")
            exit(1)
        }
    
    app.logger.logLevel = .info
    app.bot = try await .init(connectionType: .longpolling(),
                                     tgClient: TGClientDefault(),
                                     tgURI: TGBot.standardTGURL,
                                     botId: tgApi,
                                     log: app.logger)
    try await app.bot.add(dispatcher: BotDispatcher(bot: app.bot, logger: app.logger))
    try await app.bot.start()
    
    try routes(app)
}





