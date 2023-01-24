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
    func registerButtonTapped(with registerModel: RegisterModel?) async
}

protocol RegisterViewModelOutput {
    var model: ProductDetail? { get }
}

protocol RegisterViewModel: RegisterViewModelInput, RegisterViewModelOutput {}

final class DefaultRegisterViewModel: RegisterViewModel {
    private(set) var model: ProductDetail?
    private let actions: RegisterViewModelActions?
    
    init(model: ProductDetail? = nil, actions: RegisterViewModelActions? = nil) {
        self.model = model
        self.actions = actions
    }
    
    private func requestPost(with registerModel: RegisterModel) async {
        let api = RegisterProductAPI(model: registerModel)
        do {
            _ = try await api.execute()
        } catch {
            // 에러처리
            print(error.localizedDescription)
        }
    }
    
    private func requestPatch(with registerModel: RegisterModel) async {
        let editModel = registerModel.requestDTO.toEditRequestDTO()
        let api = EditProductAPI(editModel: editModel, productId: model?.id ?? 0)
        do {
            _ = try await api.execute()
        } catch {
            print(error.localizedDescription)
            // 오류얼럿
        }
    }
    
    @MainActor
    func registerButtonTapped(with registerModel: RegisterModel?) async {
        guard let registerModel = registerModel else { return }
        if model == nil {
            await requestPost(with: registerModel)
            actions?.registerButtonTapped()
        } else {
            await requestPatch(with: registerModel)
            actions?.editButtonTapped()
        }
    }
}
