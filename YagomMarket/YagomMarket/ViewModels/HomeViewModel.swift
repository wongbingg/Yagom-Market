//
//  HomeViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

protocol HomeViewModelInput {
    func resetToFirstPage()
    func addNextPage()
}

protocol HomeViewModelOutput {
    var productList: Observable<[Page]> { get set }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: HomeViewModel {
    var productList: Observable<[Page]> = Observable([])
    private var hasNext: Bool?
    private var currentPage = 1
    private let currentItemPerPage = 50
    
    func resetToFirstPage() {
        currentPage = 1
        let api = SearchProductListAPI(
            pageNumber: currentPage,
            itemPerPage: currentItemPerPage
        )
        api.execute { result in
            switch result {
            case .success(let data):
                self.hasNext = data.hasNext
                self.productList.value = data.pages
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func addNextPage() {
        guard let hasNext = hasNext, hasNext == true else { return }
        currentPage += 1
        let api = SearchProductListAPI(
            pageNumber: currentPage,
            itemPerPage: currentItemPerPage
        )
        api.execute { result in
            switch result {
            case .success(let data):
                self.hasNext = data.hasNext
                self.productList.value += data.pages
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func refresh() {
        // 특정 상품 수정 후 homeview로 나왔을 때 특정 상품의 수정사항이 반영되도록 
    }
}
