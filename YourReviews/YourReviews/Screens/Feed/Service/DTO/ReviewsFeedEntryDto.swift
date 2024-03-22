import Foundation

struct ReviewsFeedEntryDto: Decodable, Hashable {
    let author: ReviewsFeedEntryAuthorDto
    let version: String
    let rating: String
    let title: String
    let content: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(ReviewsFeedEntryAuthorDto.self, forKey: .author)
        version = try container.decode(ReviewsFeedLabelContainerDto.self, forKey: .version).label
        rating = try container.decode(ReviewsFeedLabelContainerDto.self, forKey: .rating).label
        title = try container.decode(ReviewsFeedLabelContainerDto.self, forKey: .title).label
        content = try container.decode(ReviewsFeedLabelContainerDto.self, forKey: .content).label
    }
    
    init(
        author: ReviewsFeedEntryAuthorDto,
        version: String,
        rating: String,
        title: String,
        content: String
    ) {
        self.author = author
        self.version = version
        self.rating = rating
        self.title = title
        self.content = content
    }
}

// MARK: - CodingKeys

extension ReviewsFeedEntryDto {
    private enum CodingKeys: String, CodingKey {
        case author = "author"
        case version = "im:version"
        case rating = "im:rating"
        case title = "title"
        case content = "content"
    }
}
