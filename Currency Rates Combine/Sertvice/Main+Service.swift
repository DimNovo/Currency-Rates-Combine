//
//  Main+Service.swift
//  Currency Rates Combine
//
//  Created by Dmitry Novosyolov on 21/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import Foundation
import Combine

final class MainService {
    static let shared = MainService()
    
    func fetchMain(for countryCode: String?) -> AnyPublisher<Main, Error> {
        guard let code = countryCode else {
            return
                urlSession(Main.self, with: Endpoint.default.url!)
        }
        return
            urlSession(Main.self, with: Endpoint.base(code).url!)
    }
    
}

extension MainService {
    private func urlSession<T: Codable>(_ type: T.Type, with url: URL) -> AnyPublisher<T, Error> {
        URLSession
            .shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: type.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
