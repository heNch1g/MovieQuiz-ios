//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 30.09.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject{
    func didReceiveNextQuestion(_ question: QuizQuestion)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
