//
//  Endpoint.swift
//  DefaultShopping
//
//  Created by JunHwan Kim on 2023/09/09.
//

import Foundation

enum HTTPMethodType: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var queryParameter: Encodable? { get }
}

extension Requestable {
    private func makeURL(networkConfig: NetworkConfiguration) throws -> URL {
        let baseURL = networkConfig.baseURL.absoluteString.last != "/" ? networkConfig.baseURL.absoluteString.appending("/") : networkConfig.baseURL.absoluteString
        let endpoint = baseURL.appending(path)
        guard var urlComponents = URLComponents(string: endpoint) else { throw NetworkError.url }
        var queryItems: [URLQueryItem] = []
        queryItems += networkConfig.queryParameter.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        let query = try queryParameter?.toQuery() ?? [:]
        queryItems += query.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { throw NetworkError.url }
        return url
    }
    
    func makeURLRequest(networkConfig: NetworkConfiguration , body: [String:String] = [:]) throws -> URLRequest {
        let url = try self.makeURL(networkConfig: networkConfig)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = networkConfig.header
        if !body.isEmpty {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        return request
    }
}

protocol Responsable {
    associatedtype responseType
}

extension Encodable {
    func toQuery() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        return json as? [String:Any]
    }
}

protocol Networable: Requestable, Responsable {}

struct EndPoint<T>: Networable {
    
    typealias responseType = T
    
    let path: String
    let method: HTTPMethodType
    let queryParameter: Encodable?
    
    init(path: String, method: HTTPMethodType, query: Encodable?) {
        self.path = path
        self.method = method
        self.queryParameter = query
    }
}
