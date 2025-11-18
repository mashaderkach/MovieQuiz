//
//  StatisticServiceProtocol.swift
//  MovieQuiz
// Протокол для сервиса статистики. Определяет свойства: количество игр, лучший результат и среднюю точность

import Foundation

protocol StatisticServiceProtocol {
    var gameCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
