//
//  ApiClient.swift
//  Forex
//
//  Created by Subedi, Rikesh on 16/01/21.
//

import SwiftUI
import Combine
struct APIClient {
    struct Response<T> {
        let value: T
        let reponse: URLResponse
    }

    func run<T:Decodable>(_ request: URLRequest) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (result) -> Response<T> in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                return Response(value: value, reponse: result.response)
            }
            .breakpointOnError()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
