import Combine
import Networking

/// Reviews feed service interface
/// sourcery: AutoMockable
protocol ReviewsFeedServiceProtocol: AnyObject {
    /// Fetches reviews feed
    /// - Parameter id: Application identifier
    /// - Returns: Reviews feed DTO future
    func getReviewsFeed(forAppWithId id: String) -> AnyPublisher<[ReviewsFeedEntryDto], Error>
}

/// Reviews feed service
final class ReviewsFeedService: ReviewsFeedServiceProtocol {
    
    // MARK: - Properties
    
    private let requester: Requesting
    
    // MARK: - Initialiser
    
    /// Designated initialiser
    /// - Parameter requesterConstructor: Network requester constructor
    init(requesterConstructor: (_ apiUrl: String) -> (Requesting)) {
        self.requester = requesterConstructor("https://itunes.apple.com/nl/rss")
    }
    
    // MARK: - Public
    
    func getReviewsFeed(forAppWithId id: String) -> AnyPublisher<[ReviewsFeedEntryDto], Error> {
        let request = ReviewsFeedRequest(appId: id)
        return requester.make(request: request).map { $0.feed.entry }.eraseToAnyPublisher()
    }
}
