//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 14.06.2023.
//

import UIKit
import Foundation

final class AlertPresenter: AlertPresenterProtocol {
    private weak var delegate: UIViewController?
    
    init (delegate: UIViewController) {
        self.delegate = delegate
    }
    func showQuizResult(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText,style: .default) { _ in model.completion()}
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)

    }
}
