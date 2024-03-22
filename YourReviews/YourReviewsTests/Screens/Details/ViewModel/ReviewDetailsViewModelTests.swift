import XCTest
@testable import YourReviews

/// Review details view model tests
final class ReviewDetailsViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var subject: ReviewDetailsViewModel!
    
    // MARK: - Public
    
    override func setUpWithError() throws {
        subject = ReviewDetailsViewModel(review: TestData.review)
    }
    
    override func tearDownWithError() throws {
        subject = nil
    }
    
    // MARK: - Tests
    
    func testInitialState() throws {
        // given test data
        // when screen opens
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Review details should be correctly formatted"))
        XCTAssert(
            subject.rating == "⭐️⭐️⭐️⭐️⭐️(ver: 3.1.5)" &&
            subject.author == "from: John McClaine" &&
            subject.title == "Now I have ING ho-ho-ho" &&
            subject.review == "Welcome to the party pal"
        )
        expectations[0].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
}

// MARK: - TestData

private extension ReviewDetailsViewModelTests {
    enum TestData {
        static let review = ReviewsFeedEntryDto(
            author: ReviewsFeedEntryAuthorDto(name: "John McClaine"),
            version: "3.1.5",
            rating: "5",
            title: "Now I have ING ho-ho-ho",
            content: "Welcome to the party pal"
        )
    }
}
