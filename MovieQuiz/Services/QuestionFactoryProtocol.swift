//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 13.06.2023.
//

import Foundation

protocol QuestionFactoryProtocol{
    func requestNextQuestion()
    func loadData()
}
