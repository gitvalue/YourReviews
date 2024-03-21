import Combine
import Foundation

/// Ad-hoc REST API communicator
public final class RestApiRequester: Requesting {
    
    // MARK: - Properties
    
    private let apiUrl: String
    private let encoder: Encoding
    private let decoder: Decoding
    private let header: [String: String]
    private let session: URLSession = URLSession(configuration: .default)
    
    // MARK: - Initialisers
    
    public init(apiUrl: String, encoder: Encoding, decoder: Decoding, header: [String: String]) {
        self.apiUrl = apiUrl
        self.encoder = encoder
        self.decoder = decoder
        self.header = header
    }
    
    // MARK: - Public
    
    public func make<T>(request: T) -> AnyPublisher<T.Response, Error> where T : Request {
        let urlRequest: URLRequest?
        
        switch request.method {
        case .get:
            urlRequest = urlRequestForGetRequest(request)
        case .post:
            urlRequest = urlRequestForPostRequest(request)
        }
        
        guard var urlRequest else {
            return Fail(error: URLError.badURL).eraseToAnyPublisher()
        }
        
        header.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        let publisher = session.dataTaskPublisher(
            for: urlRequest
        ).tryMap { [decoder] data, _ in
            return try decoder.decode(T.Response.self, from: data)
        }.mapError { error in
            return error as Error
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private func urlRequestForPostRequest<T>(_ request: T) -> URLRequest? where T : Request {
        guard
            let query = (apiUrl + "/" + request.relativePath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: query)
        else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try encoder.encode(body)
            } catch {
                return nil
            }
        }
        
        return urlRequest
    }
    
    private func urlRequestForGetRequest<T>(_ request: T) -> URLRequest? where T : Request {
        guard
            let query = (apiUrl + "/" + request.relativePath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: query)
        else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
            
        return urlRequest
    }
}
