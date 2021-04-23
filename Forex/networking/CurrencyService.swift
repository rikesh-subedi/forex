//
//  CurrencyService.swift
//  Forex
//
//  Created by Subedi, Rikesh on 14/01/21.
//
import SwiftUI
import Combine

protocol Service {
    associatedtype T:Codable
    var baseURL: URL {get}
    var path: String {get}
    var parameters: [String:Any] {get}
    var headers: [String: Any]? {get}
}

extension Service {
    var request: URLRequest {
        guard var urlComponent = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            fatalError()
        }
        urlComponent.queryItems = parameters.map({ (keyValue) -> URLQueryItem in
            return URLQueryItem(name: keyValue.key, value: "\(keyValue.value)")
        })
        let request = URLRequest(url: urlComponent.url!)
        return request
    }

    func execute() -> AnyPublisher<T, Error> {
        return APIClient()
            .run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

}



enum CurrencyService: Service {
    typealias T = ExchangeResponse
    case getExchangeList(src: String = "USD")
    var baseURL: URL {
        return URL(string: "http://api.currencylayer.com")!
    }

    var path: String {
        switch self {
        case .getExchangeList: return "/live"
        }
    }
    var parameters: [String : Any] {
        switch self {
        case .getExchangeList(let src):
            return ["source": src, "access_key": "62f418a3130418ac9e645df3125de789", "format": "1"]
        }
    }
    var headers: [String : Any]? {
        return [:]
    }
}
