//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
// Протокол для фабрики вопросов. Определяет метод для получения следующего вопроса

import Foundation

// создаем чеклист для фабрики: любая фабрика вопросов должна уметь выдавать следующий вопрос через метод requestNextQuestion
protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    
    func loadData()
}
