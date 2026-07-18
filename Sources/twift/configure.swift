import Vapor
import SwiftTelegramBot
import Foundation

public func configure(_ app: Application) async throws {
        guard let tgApi = ProcessInfo.processInfo.environment["TELEGRAM_BOT_TOKEN"] else {
            print("TELEGRAM_BOT_TOKEN variable wasn't found in enviroment variables")
            exit(1)
        }
    
    if let portString = ProcessInfo.processInfo.environment["PORT"], let port = Int(portString) {
        app.http.server.configuration.port = port
    }
    
    app.logger.logLevel = .debug
    app.bot = try await .init(connectionType: .longpolling(),
                                     tgClient: TGClientDefault(),
                                     tgURI: TGBot.standardTGURL,
                                     botId: tgApi,
                                     log: app.logger)
    try await app.bot.add(dispatcher: BotDispatcher(bot: app.bot, logger: app.logger))
    try await app.bot.start()
    
    try routes(app)
}





