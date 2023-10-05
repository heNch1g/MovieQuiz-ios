//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 30.09.2023.
//

import Foundation

struct GameRecord: Codable {
    
    var correct: Int
    var total: Int
    var date: Date = Date()
    
    func isGameRecord(correct count: Int) -> Bool {
        if self.correct < count {
            return false
        }
        else {
            return true
        }
    }
}

