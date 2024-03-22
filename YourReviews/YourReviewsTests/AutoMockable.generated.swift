// Generated using Sourcery 2.1.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

import Combine

@testable import YourReviews






















class FiltersRouterProtocolMock: FiltersRouterProtocol {




    //MARK: - close

    var closeVoidCallsCount = 0
    var closeVoidCalled: Bool {
        return closeVoidCallsCount > 0
    }
    var closeVoidClosure: (() -> Void)?

    func close() {
        closeVoidCallsCount += 1
        closeVoidClosure?()
    }


}
class ReviewsFeedRouterProtocolMock: ReviewsFeedRouterProtocol {




    //MARK: - openFilters

    var openFiltersFilterReviewsFilterProtocolVoidCallsCount = 0
    var openFiltersFilterReviewsFilterProtocolVoidCalled: Bool {
        return openFiltersFilterReviewsFilterProtocolVoidCallsCount > 0
    }
    var openFiltersFilterReviewsFilterProtocolVoidReceivedFilter: (ReviewsFilterProtocol)?
    var openFiltersFilterReviewsFilterProtocolVoidReceivedInvocations: [(ReviewsFilterProtocol)] = []
    var openFiltersFilterReviewsFilterProtocolVoidClosure: ((ReviewsFilterProtocol) -> Void)?

    func openFilters(_ filter: ReviewsFilterProtocol) {
        openFiltersFilterReviewsFilterProtocolVoidCallsCount += 1
        openFiltersFilterReviewsFilterProtocolVoidReceivedFilter = filter
        openFiltersFilterReviewsFilterProtocolVoidReceivedInvocations.append(filter)
        openFiltersFilterReviewsFilterProtocolVoidClosure?(filter)
    }

    //MARK: - openDetails

    var openDetailsReviewReviewsFeedEntryDtoVoidCallsCount = 0
    var openDetailsReviewReviewsFeedEntryDtoVoidCalled: Bool {
        return openDetailsReviewReviewsFeedEntryDtoVoidCallsCount > 0
    }
    var openDetailsReviewReviewsFeedEntryDtoVoidReceivedReview: (ReviewsFeedEntryDto)?
    var openDetailsReviewReviewsFeedEntryDtoVoidReceivedInvocations: [(ReviewsFeedEntryDto)] = []
    var openDetailsReviewReviewsFeedEntryDtoVoidClosure: ((ReviewsFeedEntryDto) -> Void)?

    func openDetails(_ review: ReviewsFeedEntryDto) {
        openDetailsReviewReviewsFeedEntryDtoVoidCallsCount += 1
        openDetailsReviewReviewsFeedEntryDtoVoidReceivedReview = review
        openDetailsReviewReviewsFeedEntryDtoVoidReceivedInvocations.append(review)
        openDetailsReviewReviewsFeedEntryDtoVoidClosure?(review)
    }


}
class ReviewsFeedServiceProtocolMock: ReviewsFeedServiceProtocol {




    //MARK: - getReviewsFeed

    var getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorCallsCount = 0
    var getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorCalled: Bool {
        return getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorCallsCount > 0
    }
    var getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReceivedId: (String)?
    var getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReceivedInvocations: [(String)] = []
    var getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue: AnyPublisher<[ReviewsFeedEntryDto], Error>!
    var getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorClosure: ((String) -> AnyPublisher<[ReviewsFeedEntryDto], Error>)?

    func getReviewsFeed(forAppWithId id: String) -> AnyPublisher<[ReviewsFeedEntryDto], Error> {
        getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorCallsCount += 1
        getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReceivedId = id
        getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReceivedInvocations.append(id)
        if let getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorClosure = getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorClosure {
            return getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorClosure(id)
        } else {
            return getReviewsFeedForAppWithIdIdStringAnyPublisherReviewsFeedEntryDtoErrorReturnValue
        }
    }


}
class ReviewsFilterProtocolMock: ReviewsFilterProtocol {


    var validRange: ClosedRange<Int> {
        get { return underlyingValidRange }
        set(value) { underlyingValidRange = value }
    }
    var underlyingValidRange: (ClosedRange<Int>)!
    var rating: Int?



}
