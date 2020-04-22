//
//  URL+Extension.swift
//  Currency Rates Combine
//
//  Created by Dmitry Novosyolov on 21/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import Foundation

extension URL {
    func setQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value)}
        return components?.url
    }
}
