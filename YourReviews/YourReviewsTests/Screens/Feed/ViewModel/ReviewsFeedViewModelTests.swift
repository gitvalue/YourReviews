import Combine
import XCTest
@testable import YourReviews

/// Reviews feed view model tests
final class ReviewsFeedViewModelTests: XCTestCase {
    
    // MARK: - Events
    
    private var pullToRefreshEventPublisher: PassthroughSubject<Void, Never>!
    private var cellSelectionEventPublisher: PassthroughSubject<ReviewsFeedViewModel.ReviewCellModel, Never>!
    
    // MARK: - Properties
    
    private var subscriptions: [AnyCancellable]!
    private var service: ReviewsFeedServiceProtocolMock!
    private var router: ReviewsFeedRouterProtocolMock!
    private var subject: ReviewsFeedViewModel!
    
    // MARK: - Public
    
    override func setUpWithError() throws {
        subscriptions = []
        pullToRefreshEventPublisher = PassthroughSubject<Void, Never>()
        cellSelectionEventPublisher = PassthroughSubject<ReviewsFeedViewModel.ReviewCellModel, Never>()
        service = ReviewsFeedServiceProtocolMock()
        router = ReviewsFeedRouterProtocolMock()
    }
    
    override func tearDownWithError() throws {
        subscriptions = nil
        pullToRefreshEventPublisher = nil
        cellSelectionEventPublisher = nil
        service = nil
        router = nil
        subject = nil
    }
    
    // MARK: - Tests
    
    func testInitialState() throws {
        // given test data
        let feedPublisher = PassthroughSubject<[ReviewsFeedEntryDto], Error>()
        service.getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue = feedPublisher.eraseToAnyPublisher()
        subject = ReviewsFeedViewModel(service: service, router: router)
        
        // when feed request completes
        feedPublisher.send(TestData.feed)
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Feed should be accordingly updated"))
        subject.$reviews.sink { reviews in
            XCTAssert(
                reviews[0].rating == "⭐️(ver: 1.0.0)" &&
                reviews[0].author == "from: John Wayne" &&
                reviews[0].title == "Best bank ever" &&
                reviews[0].review == "Pros — good application \n Cons — I don't have an iPhone"
            )
            XCTAssert(
                reviews[1].rating == "⭐️⭐️⭐️⭐️(ver: 2.0.0)" &&
                reviews[1].author == "from: John Doe" &&
                reviews[1].title == "Best app ever for those who's alive" &&
                reviews[1].review == "Pros — great application \n Cons — I wish I wasn't so dead"
            )
            
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testCellPress() throws {
        // given test data
        let feedPublisher = PassthroughSubject<[ReviewsFeedEntryDto], Error>()
        service.getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue = feedPublisher.eraseToAnyPublisher()
        subject = ReviewsFeedViewModel(service: service, router: router)
        subject.subscribeToCellSelectionEvent(cellSelectionEventPublisher.eraseToAnyPublisher())
        feedPublisher.send(TestData.feed)
        
        // when feed row is selected
        cellSelectionEventPublisher.send(ReviewsFeedViewModel.ReviewCellModel.model(fromDto: TestData.feed[1]))
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Details screen should open"))
        XCTAssert(router.openDetailsReviewReviewsFeedEntryDtoVoidCalled)
        XCTAssert(router.openDetailsReviewReviewsFeedEntryDtoVoidReceivedReview == TestData.feed[1])
        expectations[0].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testFilterButtonPress() throws {
        // given test data
        let feedPublisher = PassthroughSubject<[ReviewsFeedEntryDto], Error>()
        service.getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue = feedPublisher.eraseToAnyPublisher()
        subject = ReviewsFeedViewModel(service: service, router: router)
        feedPublisher.send(TestData.feed)
        
        // when user presses 'Filters' button
        subject.header?.filterButtonPressEventPublisher.send()
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Filters screen should open"))
        XCTAssert(router.openFiltersFilterReviewsFilterProtocolVoidCalled)
        expectations[0].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testFeedFiltering() throws {
        // given test data
        let feedPublisher = PassthroughSubject<[ReviewsFeedEntryDto], Error>()
        service.getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue = feedPublisher.eraseToAnyPublisher()
        subject = ReviewsFeedViewModel(service: service, router: router)
        feedPublisher.send(TestData.feed)
        
        var filter: ReviewsFilterProtocol!
        router.openFiltersFilterReviewsFilterProtocolVoidClosure = { receivedFilter in
            filter = receivedFilter
        }
        
        subject.header?.filterButtonPressEventPublisher.send()
        
        // when user selects rating filter setting
        filter.rating = 4
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Feed should contain only filtered results"))
        XCTAssert(subject.reviews.count == 1)
        XCTAssert(
            subject.reviews[0].rating == "⭐️⭐️⭐️⭐️(ver: 2.0.0)" &&
            subject.reviews[0].author == "from: John Doe" &&
            subject.reviews[0].title == "Best app ever for those who's alive" &&
            subject.reviews[0].review == "Pros — great application \n Cons — I wish I wasn't so dead"
        )
        expectations[0].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testHeader() throws {
        // given test data
        let feedPublisher = PassthroughSubject<[ReviewsFeedEntryDto], Error>()
        service.getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue = feedPublisher.eraseToAnyPublisher()
        subject = ReviewsFeedViewModel(service: service, router: router)
        
        // when feed loads
        feedPublisher.send(TestData.feed)
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Header title should be correct"))
        XCTAssert(subject.header?.topWordsTitle == "Top 3 words:")
        expectations[0].fulfill()
        
        expectations.append(XCTestExpectation(description: "Top words should be calculated correctly"))
        XCTAssert(subject.header?.topWords == "application, Pros, Cons")
        expectations[1].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
}

// MARK: - TestData

private extension ReviewsFeedViewModelTests {
    enum TestData {
        static let feed: [ReviewsFeedEntryDto] = [
            ReviewsFeedEntryDto(
                author: ReviewsFeedEntryAuthorDto(name: "John Wayne"),
                version: "1.0.0",
                rating: "1",
                title: "Best bank ever",
                content: "Pros — good application \n Cons — I don't have an iPhone"
            ),
            ReviewsFeedEntryDto(
                author: ReviewsFeedEntryAuthorDto(name: "John Doe"),
                version: "2.0.0",
                rating: "4",
                title: "Best app ever for those who's alive",
                content: "Pros — great application \n Cons — I wish I wasn't so dead"
            ),
        ]
    }
}
