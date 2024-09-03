//
//  Push.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 02.11.2023.
//

import Foundation
import CocoaLumberjackSwift

struct Push: Decodable {
    enum CodingKeys: String, CodingKey {
        case aps
    }

    let aps: Aps

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        aps = try container.decode(Aps.self, forKey: .aps)
    }
}

struct Aps: Decodable {
    enum CodingKeys: String, CodingKey {
        case alert
        case badge
    }

    let alert: PushAlert
    let badge: Int?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // alert might be string
        if let alertString = try? container.decode(String.self, forKey: .alert) {
            self.alert = PushAlert(body: alertString)
        } else {
            self.alert = try container.decode(PushAlert.self, forKey: .alert)
        }

        self.badge = try? container.decode(Int?.self, forKey: .badge)
    }
}

struct PushAlert: Decodable {

    enum CodingKeys: String, CodingKey {
        case body
    }

    let body: String

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        body = (try? container.decode(String.self, forKey: .body)) ?? ""
    }

    fileprivate init(body: String) {
        self.body = body
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {

    var pushValue: Push? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try JSONDecoder().decode(Push.self, from: jsonData)
        } catch {
            DDLogError("#PUSH decode error: \(error.localizedDescription)")
            return nil
        }
    }
}
