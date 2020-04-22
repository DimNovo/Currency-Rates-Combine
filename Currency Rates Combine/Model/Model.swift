//
//  Model.swift
//  Currency Rates Combine
//
//  Created by Dmitry Novosyolov on 21/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import Foundation

struct Main {
    let id = UUID()
    let date: String?
    let rates: [String: Double]?
}

extension Main: Codable, Identifiable, Equatable {
    static var placeholder: Main { Self(date: nil, rates: nil)}
}

enum Endpoint {
    case base(_: String)
    case `default`
    private var baseURL: URL { URL(string: "https://api.exchangeratesapi.io/latest")!}
    var url: URL? { baseURL.setQueries(query())}
    func query() -> [String: String] {
        switch self {
            case let .base(base):
                return ["base": base]
            case .default:
                return ["base": "ILS"]
        }
    }
}
