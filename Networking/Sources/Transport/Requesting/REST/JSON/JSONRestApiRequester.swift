import Combine
import Foundation

/// JSON-encoded requests manager
public final class JSONRestApiRequester: Requesting {
    
    // MARK: - Properties
    
    private let requester: RestApiRequester
    
    /// Designated initialiser
    /// - Parameter apiUrl: URL of the API
    public init(apiUrl: String) {
        self.requester = RestApiRequester(
            apiUrl: apiUrl,
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            header: [
                "Accept": "application/json"
            ]
        )
    }
    
    // MARK: - Public
    
    public func make<T>(request: T) -> AnyPublisher<T.Response, Error> where T : Request {
        return requester.make(request: request)
    }
}
