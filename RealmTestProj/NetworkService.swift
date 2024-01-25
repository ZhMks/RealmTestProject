//
//  NetworkService.swift
//  RealmTestProj
//
//  Created by Максим Жуин on 15.01.2024.
//

import Foundation

final class NetworkService {

    func fetchQuote(with url: URL?, compeltion: @escaping ((Result<NetworkModel, Error>) -> Void)) {
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let quote = try decoder.decode(NetworkModel.self, from: data)
                            compeltion(.success(quote))
                        } catch {
                            compeltion(.failure(error))
                        }
                    }
                case 502:
                    compeltion(.failure(error!))
                case 404:
                    compeltion(.failure(error!))
                default: break
                }
            }
        }
        dataTask.resume()
    }

}
