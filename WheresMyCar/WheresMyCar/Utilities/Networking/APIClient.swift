//
//  APIClient.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/10.
//  Copyright © 2019 EggWin. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct HTTPHeader {
    let field: String
    let value: String
}

enum URLPath: String {
    case posts = "posts"
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [URLQueryItem]?
    var headers: [HTTPHeader]?
    var body: Data?
    
    init(method: HTTPMethod, path: URLPath) {
        self.method = method
        self.path = path.rawValue
    }
    
    init<Body: Encodable>(method: HTTPMethod, path: URLPath, body: Body) throws {
        self.method = method
        self.path = path.rawValue
        self.body = try JSONEncoder().encode(body)
    }
}

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

extension APIResponse where Body == Data? {
    func decode<BodyType: Decodable>(to type: BodyType.Type) throws -> APIResponse<BodyType> {
        guard let data = body else {
            throw APIError.decodingFailure
        }
        let decodeJSON = try JSONDecoder().decode(BodyType.self, from: data)
        return APIResponse<BodyType>(statusCode: self.statusCode, body: decodeJSON)
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailure
}

enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}

struct APIClient {
    typealias APIClientCompletionHandler = (APIResult<Data?>) -> Void
    
    private let session = URLSession.shared
    private var baseURL = URL(string: "https://jsonplaceholder.typicode.com")!
    
    func perform(_ request: APIRequest, completionHandler: @escaping APIClientCompletionHandler) {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path
        urlComponents.queryItems = request.queryItems
        
        guard let url = urlComponents.url?.appendingPathComponent(request.path) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(.failure(.requestFailed))
                return
            }
            completionHandler(.success(APIResponse<Data?>(statusCode: httpResponse.statusCode, body: data)))
        }
        task.resume()
    }
}

// fake model
struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
