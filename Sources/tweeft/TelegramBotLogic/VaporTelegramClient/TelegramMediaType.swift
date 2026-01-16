//
//  TelegramMediaType.swift
//  Vapor-Telegram-Bot
//
//  Created by br3nd4nt on 16.01.2026.
//

public enum TGHTTPMediaType: String, Equatable {
    case formData
    case json
}

struct TGEmptyParams: Encodable {}
