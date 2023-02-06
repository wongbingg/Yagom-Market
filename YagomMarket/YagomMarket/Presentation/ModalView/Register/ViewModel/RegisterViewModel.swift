//
//  RegisterViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/29.
//

struct RegisterViewModelActions {
    let registerButtonTapped: () -> Void
    let editButtonTapped: () -> Void
}

protocol RegisterViewModelInput {
    func registerButtonTapped(with registerModel: RegisterModel?) async throws
}

protocol RegisterViewModelOutput {
    var model: ProductDetail? { get }
}

protocol RegisterViewModel: RegisterViewModelInput, RegisterViewModelOutput {}

final class DefaultRegisterViewModel: RegisterViewModel {
    private(set) var model: ProductDetail?
    private let actions: RegisterViewModelActions?
    private let registerProductUseCase: RegisterProductUseCase?
    private let editProductUseCase: EditProductUseCase?
    
    init(
        model: ProductDetail? = nil,
        actions: RegisterViewModelActions? = nil,
        registerProductUseCase: RegisterProductUseCase? = nil,
        editProductUseCase: EditProductUseCase? = nil
    ) {
        self.model = model
        self.actions = actions
        self.registerProductUseCase = registerProductUseCase
        self.editProductUseCase = editProductUseCase
    }
    
    private func requestPost(with registerModel: RegisterModel) async throws {
        try await registerProductUseCase?.execute(with: registerModel)
    }
    
    private func requestPatch(with registerModel: RegisterModel) async throws {
        let editModel = registerModel.requestDTO.toEditRequestDTO()
        try await editProductUseCase?.execute(with: editModel, productId: model?.id ?? 0)
    }
    
    @MainActor
    func registerButtonTapped(with registerModel: RegisterModel?) async throws {
        guard let registerModel = registerModel else { return }
        if model == nil {
            try await requestPost(with: registerModel)
            actions?.registerButtonTapped()
        } else {
            try await requestPatch(with: registerModel)
            actions?.editButtonTapped()
        }
    }
}
