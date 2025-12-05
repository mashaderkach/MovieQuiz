//
//  StatisticServiceProtocol.swift
//  MovieQuiz
// Протокол для сервиса статистики. Определяет свойства: количество игр, лучший результат и среднюю точность

import Foundation

protocol StatisticServiceProtocol {
    // количество сыгранных игр
    var gameCount: Int { get }
    
    //  лучший результат игры
    var bestGame: GameResult { get }
    
    // общая средняя точность ответов в процентах
    var totalAccuracy: Double { get }
    
    // метод сохранения результатов игры, где correct count - кол-во правильных ответов, а total amount - общее кол-во вопросов
    func store(correct count: Int, total amount: Int)
}
