//
//  AlertModel.swift
//  MovieQuiz
// Модель данных для алерта. Храниит заголовок, сообщение, текст кнопки и действие при нажатии кнопки

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
