//
//  GameResult.swift
//  MovieQuiz
// Модель результата одного раунда викторины. Хранит количество правильных ответов, общее количество вопросов и дату, а также умеет сравнивать результаты

import Foundation

struct GameResult {
    let correct: Int // кол-во правильных ответов
    let total: Int // кол-во вопросов квиза
    let date: Date // дата завершения раунда
    
    // метод сравнения по кол-ву верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}
