//
//  ImagesManager.swift
//  Messenger
//
//  Created by Христиченко Александр on 2023-06-14.
//

import UIKit

struct ImagesManager {
    func fetchMessages(completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: "https://cdn2.thecatapi.com/images/Z6d8vsYAo.jpg") else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }
                let image = UIImage(data: data)
                completion(.success((image ?? UIImage(systemName: "person.circle")!)))
            }
        }.resume()
    }
}
