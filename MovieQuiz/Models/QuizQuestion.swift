//
//  QuizQuestion.swift
//  MovieQuiz
// Модель одного вопроса викторины. Хранит имя картинки, текст вопроса и правильный ответ

import Foundation

 struct QuizQuestion {
    let image: Data 
    let text: String // строка с воспросом о рейтинге фильма
    let correctAnswer: Bool // правильный ответ на вопрос
}
