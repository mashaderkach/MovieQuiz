//
//  NetworkClient.swift
//  MovieQuiz
// Задача - загружать данные, но не преобразовывать их

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}


/// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {

    // создаем свою реализацию протокола, чтобы обозначить его на случай, если произойдет ошибка
    private enum NetworkError: Error {
        case codeError
    }
    
    // делает сетевой запрос и возвращает либо успех с данными типа Data, либо ошибку через замыкание
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        // создаем запрос из url
        let request = URLRequest(url: url)
        
        // создаем сетевую задачу, которая отправляет запрос в интернет и вызывает замыкание с data, response code и error, когда сервер ответит
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверяем, пришла ли ошибка: если да - возвращаем .failure(error) 
            if let error = error {
                handler(.failure(error))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
}
