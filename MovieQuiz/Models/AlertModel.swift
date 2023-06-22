//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alexey Volovikov on 14.06.2023.
//

import Foundation
public struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
