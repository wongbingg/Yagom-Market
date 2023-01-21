//
//  ResultViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2023/01/20.
//

struct ResultViewModelAction {
    let cellTapped: (Int) -> Void
}
protocol ResultViewModelInput {
    func didSelectItemAt(indexPath: Int)
}
protocol ResultViewModelOutput {
    var model: ProductListResponseDTO { get }
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput {}

final class DefaultResultViewModel: ResultViewModel {
    var model: ProductListResponseDTO
    let actions: ResultViewModelAction
    
    init(model: ProductListResponseDTO, actions: ResultViewModelAction) {
        self.model = model
        self.actions = actions
    }
    
    func didSelectItemAt(indexPath: Int) {
        let id = model.pages[indexPath].id
        actions.cellTapped(id)
    }
}
