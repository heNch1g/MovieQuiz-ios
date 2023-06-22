//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 20.06.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: BestGame? { get }
    func store(correct: Int, total: Int)
}
