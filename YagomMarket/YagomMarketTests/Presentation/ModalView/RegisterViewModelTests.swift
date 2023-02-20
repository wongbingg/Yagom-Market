//
//  RegisterViewModelTests.swift
//  YagomMarketTests
//
//  Created by 이원빈 on 2023/02/06.
//

import XCTest
@testable import YagomMarket

final class RegisterViewModelTests: XCTestCase {
    private var sut: RegisterViewModel!
    private var registerProductUseCaseMock: RegisterProductUseCaseMock!
    private var editProductUseCaseMock: EditProductUseCaseMock!

    override func setUpWithError() throws {
        registerProductUseCaseMock = RegisterProductUseCaseMock()
        editProductUseCaseMock = EditProductUseCaseMock()
        sut = DefaultRegisterViewModel(
            registerProductUseCase: registerProductUseCaseMock,
            editProductUseCase: editProductUseCaseMock
        )
    }

    override func tearDownWithError() throws {
        registerProductUseCaseMock = nil
        editProductUseCaseMock = nil
        sut = nil
    }
    
    func test_전달된모델이없을때_registerButton을탭하면_RegisterProductUseCase가실행되는지() async throws {
        // given
        let expectationRegisterCallCount = 1
        let expectationEditCallCount = 0
        
        // when
        let registerModel = RegisterModel(requestDTO: ProductPostRequestDTO.stub(), images: nil)
        try await sut.registerButtonTapped(with: registerModel)
        
        // then
        XCTAssertEqual(expectationRegisterCallCount, registerProductUseCaseMock.callCount)
        XCTAssertEqual(expectationEditCallCount, editProductUseCaseMock.callCount)
    }
    
    func test_전달된모델이있을때_registerButton을탭하면_EditProductUseCase가실행되는지() async throws {
        // given
        let expectationRegisterCallCount = 0
        let expectationEditCallCount = 1
        
        let model = ProductDetail.stub()
        sut = DefaultRegisterViewModel(
            model: model,
            registerProductUseCase: registerProductUseCaseMock,
            editProductUseCase: editProductUseCaseMock
        )
        
        // when
        let registerModel = RegisterModel(requestDTO: ProductPostRequestDTO.stub(), images: nil)
        try await sut.registerButtonTapped(with: registerModel)
        
        // then
        XCTAssertEqual(expectationRegisterCallCount, registerProductUseCaseMock.callCount)
        XCTAssertEqual(expectationEditCallCount, editProductUseCaseMock.callCount)
    }
}
