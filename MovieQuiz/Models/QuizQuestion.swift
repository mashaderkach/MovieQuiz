//
//  QuizQuestion.swift
//  MovieQuiz
// Модель одного вопроса викторины. Хранит имя картинки, текст вопроса и правильный ответ

import Foundation

 struct QuizQuestion {
    let image: String // строка с названием фильма (совпадает с названием картинки-афиши фильма из Assets)
    let text: String // строка с воспросом о рейтинге фильма
    let correctAnswer: Bool // правильный ответ на вопрос
}
