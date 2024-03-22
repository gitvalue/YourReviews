import Combine
import XCTest
@testable import YourReviews

/// Test cases for `FiltersViewModel`
final class FiltersViewModelTests: XCTestCase {
    
    // MARK: - Events
    
    private var starSelectionEventPublisher: PassthroughSubject<Int, Never>!
    private var applyButtonPressEventPublisher: PassthroughSubject<Void, Never>!
    
    // MARK: - Properties
    
    private var subscriptions: [AnyCancellable]!
    private var filter: ReviewsFilterProtocolMock!
    private var router: FiltersRouterProtocolMock!
    private var subject: FiltersViewModel!
    
    // MARK: - Public
    
    override func setUpWithError() throws {
        starSelectionEventPublisher = PassthroughSubject<Int, Never>()
        applyButtonPressEventPublisher = PassthroughSubject<Void, Never>()
        subscriptions = []
        filter = ReviewsFilterProtocolMock()
        router = FiltersRouterProtocolMock()
    }
    
    override func tearDownWithError() throws {
        starSelectionEventPublisher = nil
        applyButtonPressEventPublisher = nil
        subscriptions = nil
        filter = nil
        router = nil
        subject = nil
    }
    
    // MARK: - Tests
    
    func testInitialState() throws {
        // given test data
        filter.validRange = 1...5
        filter.rating = 3
        
        // when filters screen is shown
        subject = FiltersViewModel(filter: filter, router: router)
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Apply button title should be correct"))
        XCTAssert(subject.applyButtonTitle == "Apply")
        expectations[0].fulfill()
        
        expectations.append(XCTestExpectation(description: "Stars filter model should be correct"))
        subject.$starsFilterModel.sink { model in
            XCTAssert(model.title == "Stars:")
            XCTAssert(
                model.stars[0].isFilled == true &&
                model.stars[1].isFilled == true &&
                model.stars[2].isFilled == true &&
                model.stars[3].isFilled == false &&
                model.stars[4].isFilled == false
            )
            expectations[1].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testStarSelection() throws {
        // given test data
        filter.validRange = 1...5
        filter.rating = nil
        
        // when user selects a star
        subject = FiltersViewModel(filter: filter, router: router)
        subject.subscribeToStarSelectionEvent(starSelectionEventPublisher.eraseToAnyPublisher())
        starSelectionEventPublisher.send(1)
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Stars model should be updated accordingly"))
        subject.$starsFilterModel.sink { model in
            XCTAssert(
                model.stars[0].isFilled == true &&
                model.stars[1].isFilled == true &&
                model.stars[2].isFilled == false &&
                model.stars[3].isFilled == false &&
                model.stars[4].isFilled == false
            )
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testSameStarSelection() throws {
        // given test data
        filter.validRange = 1...5
        filter.rating = 4
        
        // when user selects the same star twice
        subject = FiltersViewModel(filter: filter, router: router)
        subject.subscribeToStarSelectionEvent(starSelectionEventPublisher.eraseToAnyPublisher())
        starSelectionEventPublisher.send(3)
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Filter should be reset"))
        subject.$starsFilterModel.sink { model in
            XCTAssert(
                model.stars[0].isFilled == false &&
                model.stars[1].isFilled == false &&
                model.stars[2].isFilled == false &&
                model.stars[3].isFilled == false &&
                model.stars[4].isFilled == false
            )
            expectations[0].fulfill()
        }.store(
            in: &subscriptions
        )
        
        wait(for: expectations, timeout: 5.0)
    }
    
    func testApplyButtonPress() throws {
        // given test data
        filter.validRange = 1...5
        filter.rating = 1
        
        // when user presses 'Apply' button
        subject = FiltersViewModel(filter: filter, router: router)
        
        subject.subscribeToStarSelectionEvent(starSelectionEventPublisher.eraseToAnyPublisher())
        starSelectionEventPublisher.send(2)
        
        subject.subscribeToApplyButtonPressEvent(applyButtonPressEventPublisher.eraseToAnyPublisher())
        applyButtonPressEventPublisher.send()
        
        // then
        var expectations: [XCTestExpectation] = []
        expectations.append(XCTestExpectation(description: "Filter should be updated"))
        XCTAssert(filter.rating == 3)
        expectations[0].fulfill()
        
        expectations.append(XCTestExpectation(description: "Screen should be closed"))
        XCTAssert(router.closeVoidCalled)
        expectations[1].fulfill()
        
        wait(for: expectations, timeout: 5.0)
    }
}
