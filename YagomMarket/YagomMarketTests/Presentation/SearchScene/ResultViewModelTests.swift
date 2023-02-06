//
//  ResultViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/03.
//

import XCTest
@testable import YagomMarket

final class ResultViewModelTests: XCTestCase {
    var sut: ResultViewModel!
    var passedId = 0
    
    override func setUpWithError() throws {
        let viewModelAction = ResultViewModelAction(
            cellTapped: cellTapped
        )
        
        func cellTapped(id: Int) {
            passedId = id
        }
        
        sut = DefaultResultViewModel(
            cells: [ProductCell.stub(id: 123)],
            actions: viewModelAction
        )
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_didSelectItemAt메서드가실행될때_indexPath에해당하는_상품의id값을가져가서viewModelActions_cellTapped를실행하는지() {
        // given
        let expectationId = 123
        // when
        sut.didSelectItemAt(indexPath: 0)
        // then
        XCTAssertEqual(expectationId, passedId)
    }
}
