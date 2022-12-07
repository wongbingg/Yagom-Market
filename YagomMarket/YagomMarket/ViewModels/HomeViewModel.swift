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
    private let currentItemPerPage = 20
    
    func resetToFirstPage() {
        currentPage = 1
        let api = makeAPI()
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
        let api = makeAPI()
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
    
    private func makeAPI() -> SearchProductListAPI {
        let param = makeParameter()
        let apiCon = makeAPIConfiguration(with: param)
        return SearchProductListAPI(configuration: apiCon)
    }
    
    private func makeParameter() -> [String: Any] {
        return  ["page_no": currentPage, "items_per_page": currentItemPerPage]
    }
    
    private func makeAPIConfiguration(with param: [String: Any]?) -> APIConfiguration {
        return APIConfiguration(
            method: .get,
            base: URLCommand.host,
            path: URLCommand.products,
            parameters: param
        )
    }
}
