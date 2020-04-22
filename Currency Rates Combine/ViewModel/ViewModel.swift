//
//  ViewModel.swift
//  Currency Rates Combine
//
//  Created by Dmitry Novosyolov on 21/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import Foundation
import Combine

final class ViewModel: ObservableObject {
    
    @Published var main: Main? = nil
    @Published var countryCode: String? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() { fetchRates()}
    
    func fetchRates() {
        MainService.shared.fetchMain(for: countryCode)
            .replaceError(with: Main.placeholder)
            .sink(receiveValue: { [weak self] in self?.main = $0 })
            .store(in: &cancellableSet)
    }
    
    deinit {
        cancellableSet.forEach { $0.cancel()}
    }
}

extension ViewModel {
    
    func emojiFlag(_ countryCode: String) -> String {
        var string = ""
        countryCode
            .dropLast()
            .localizedUppercase
            .unicodeScalars
            .forEach {
                string
                    .append(UnicodeScalar(127397 + $0.value)!.description)
        }
        return string
    }
    
    func parsedOutput(for key: String) -> String {
        guard let mainRates = main?.rates else { return "" }
        let rate = mainRates.filter { $0.key == key }
        var formatter: NumberFormatter {
            let fm = NumberFormatter()
            fm.numberStyle = .currency
            fm.locale = Locale(identifier: key.dropLast() + "_" + key.dropLast().uppercased())
            return fm
        }
        return
            formatter.string(from: NSNumber(value: rate[key] ?? 1.0))!
    }
    
    func validatedOutput() -> [Dictionary<String, Double>.Keys.Element] {
        guard let tmp = main?.rates?.filter({ $0.key != countryCode ?? "ILS" }).keys.sorted() else { return []}
        return tmp
    }
}
