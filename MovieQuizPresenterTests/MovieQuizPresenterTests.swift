//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Alexey Volovikov on 01.10.2023.
//
import Foundation
import XCTest
import UIKit

@testable import MovieQuiz

final class MovieQuizViewControllerMock: UIViewController, MovieQuizViewControllerProtocol {
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showBorderResult(isCorrect: Bool) {}
    func isHideBorder() {}
    func isEnabledButtons(_ isEnabled: Bool) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", corretAwner: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}



