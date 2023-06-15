//
//  MessagesManager.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-13.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case decodingError
    case badURL
}

struct MessagesManager {
    func fetchMessages(offset: Int, completion: @escaping (Result<Message, NetworkError>) -> Void) {
        guard let url = URL(string: "https://numia.ru/api/getMessages?offset=\(offset)") else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                do {
                    let messages = try JSONDecoder().decode(Message.self, from: data)
                    completion(.success(messages))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
