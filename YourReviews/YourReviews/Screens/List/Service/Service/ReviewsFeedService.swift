import Combine
import Networking

protocol ReviewsFeedServiceProtocol: AnyObject {
    func getReviewsFeed(forAppWithId id: String) -> AnyPublisher<[ReviewsFeedEntryDto], Error>
}

final class ReviewsFeedService: ReviewsFeedServiceProtocol {
    
    // MARK: - Properties
    
    private let requester: Requesting
    
    // MARK: - Initialiser
    
    init(requesterConstructor: (_ apiUrl: String) -> (Requesting)) {
        self.requester = requesterConstructor("https://itunes.apple.com/nl/rss")
    }
    
    // MARK: - Public
    
    func getReviewsFeed(forAppWithId id: String) -> AnyPublisher<[ReviewsFeedEntryDto], Error> {
        let request = ReviewsFeedRequest(appId: id)
        return requester.make(request: request).map { $0.feed.entry }.eraseToAnyPublisher()
    }
}
