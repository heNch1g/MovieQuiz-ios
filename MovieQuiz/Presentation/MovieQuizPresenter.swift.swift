//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 30.09.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    
    var currentQuestion: QuizQuestion?
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    let questionAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0

    init(viewController: MovieQuizViewController) {
           self.viewController = viewController
           
           questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
           questionFactory?.loadData()
           viewController.showLoadingIndicator()
       }
    
    func isLastQuestion() -> Bool {
           currentQuestionIndex == questionAmount - 1
       }
    
    func resetQuestionIndex() {
            currentQuestionIndex = 0
        }
    
    func switchToNextQuestion() {
            currentQuestionIndex += 1
        }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel (
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
     func didAnswer(isYes: Bool) {
            guard let currentQuestion = currentQuestion else {
                return
            }
            
            let givenAnswer = isYes
            
            viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        }
    
    func didReceiveNextQuestion(_ question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }

    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            viewController?.showAlert()
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func restartGame() {
            currentQuestionIndex = 0
            correctAnswers = 0
            questionFactory?.requestNextQuestion()
        }
}
