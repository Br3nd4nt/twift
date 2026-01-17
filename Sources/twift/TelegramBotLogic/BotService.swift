//
//  BotService.swift
//  twift
//
//  Created by br3nd4nt on 16.01.2026.
//

import Vapor
import SwiftTelegramBot

extension Application {
    private struct TGServiceServiceKey: StorageKey {
        typealias Value = TGBot
    }

    var bot: TGBot {
        get {
            guard let service = storage[TGServiceServiceKey.self] else {
                fatalError("TGBot not configured. Use app.bot = ...")
            }
            return service
        }
        set {
            storage[TGServiceServiceKey.self] = newValue
        }
    }
}
