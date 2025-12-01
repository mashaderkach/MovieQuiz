//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
// Протокол делегата фабрики вопросов. Определяет метод для получения вопросов фабрикой

import Foundation

// создаем чеклист того, что должен уметь делегат, т.е. любой объект, который хочет получать вопросы от фабрики, должен уметь обработать новый вопрос через метод didReceiveNextQuestion()
protocol QuestionFactoryDelegate: AnyObject {
    
    // метод, который должен быть у делегата фабрики - его будет вызывать фабрика, чтобы отдать готовый вопрос квиза
    func didReceiveNextQuestion(question: QuizQuestion?)
    
    func didLoadDataFromServer() // сообщение об успешной загрузке
    
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
