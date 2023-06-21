//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 19.06.2023.
//

import Foundation

final class StatisticServiceImplementation {
    private let userDefaults: UserDefaults
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let dateProvider: () -> Date
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    init(userDefaults: UserDefaults,
         decoder: JSONDecoder,
         encoder: JSONEncoder,
         dateProvider: @escaping () -> Date
    ) {
        self.userDefaults = userDefaults
        self.encoder = encoder
        self.decoder = decoder
        self.dateProvider = dateProvider
    }
}

extension StatisticServiceImplementation: StatisticService {
        
    var gamesCount: Int {
        get  {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var total: Int {
        get  {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    var totalAccuracy: Double {
        (Double(correct) / Double(total)) * 100
    }
    
    var correct: Int {
        get  {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var bestGame: BestGame? {
        get {
            guard
                  let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let bestGame = try? decoder.decode(BestGame.self, from: data) else {
                return nil
            }
            return bestGame
        }
        set {
            let data = try? encoder.encode(newValue)
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        self.correct += correct
        self.total += total
        self.gamesCount += 1
        let date = dateProvider()
        let currentBestGame = BestGame(correct: correct, total: total, date: date)
     
        guard let previousBestGame = bestGame else {
                    bestGame = currentBestGame
                    return
                }
                if previousBestGame > currentBestGame {
                    bestGame = currentBestGame
                }
    }
}

struct BestGame: Codable {
    let correct: Int
    let total: Int
    let date: Date
}

extension BestGame: Comparable {
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        return Double(correct) / Double(total)
        
    }
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.accuracy < rhs.accuracy
    }
}
