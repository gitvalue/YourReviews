import Foundation

struct ReviewsFeedEntryAuthorDto: Decodable, Hashable {
    let name: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let labelContainer = try container.decode(ReviewsFeedLabelContainerDto.self, forKey: .name)
        self.name = labelContainer.label
    }
    
    init(name: String) {
        self.name = name
    }
}

// MARK: - CodingKeys

extension ReviewsFeedEntryAuthorDto {
    private enum CodingKeys: CodingKey {
        case name
    }
}
