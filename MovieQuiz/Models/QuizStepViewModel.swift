//
//  QuizStepViewModel.swift
//  MovieQuiz
// Модель для отображения одного шага квиза. Хранит данные для показа вопроса: картинку, текст вопроса, номер вопроса

import Foundation
import UIKit

// отображение на экране
 struct QuizStepViewModel {
    let image: UIImage // сама картинка с афишей фильма
    let question: String // вопрос о рейтинге квиза
    let questionNumber: String // номер текущего вопроса ("1/10")
}
