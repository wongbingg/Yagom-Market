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
    var productCells: [ProductCell] { get }
}

protocol ResultViewModel: ResultViewModelInput, ResultViewModelOutput {}

final class DefaultResultViewModel: ResultViewModel {
    var productCells: [ProductCell]
    let actions: ResultViewModelAction
    
    init(cells: [ProductCell], actions: ResultViewModelAction) {
        self.productCells = cells
        self.actions = actions
    }
    
    func didSelectItemAt(indexPath: Int) {
        let id = productCells[indexPath].id
        actions.cellTapped(id)
    }
}
