//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 01.10.2023.
//
import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject, UIViewController {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showBorderResult(isCorrect: Bool)
    func isHideBorder()
    func isEnabledButtons(_ isEnabled: Bool)
}
