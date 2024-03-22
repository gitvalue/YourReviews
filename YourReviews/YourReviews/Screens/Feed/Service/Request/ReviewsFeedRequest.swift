import Networking

/// AppStore reviews feed request model
struct ReviewsFeedRequest: Request {
    struct Response: Decodable {
        let feed: ReviewsFeedDto
    }
    
    struct Body: Encodable {}
    
    var relativePath: String {
        return "customerreviews/id=\(appId)/sortby=mostrecent/json"
    }
    
    let method: HttpMethod = .get
    let body: Body? = nil
    
    private let appId: String
    
    /// Designated initialiser
    /// - Parameter appId: Application identifier
    init(appId: String) {
        self.appId = appId
    }
}
