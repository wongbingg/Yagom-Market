//
//  HomeViewModel.swift
//  YagomMarket
//
//  Created by 이원빈 on 2022/11/28.
//

protocol HomeViewModelInput {
    func requestProductList(pageNumber: Int,
                            ItemPerPages: Int,
                            vendorName: String?)
}

protocol HomeViewModelOutput {
    var productList: Observable<[Page]> { get set }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: HomeViewModel {
    var productList: Observable<[Page]> = Observable([])
    
    func requestProductList(pageNumber: Int,
                            ItemPerPages: Int,
                            vendorName: String? = nil) {
        var param: [String: Any]?
        if let vendorName = vendorName {
            param = ["page_no": pageNumber,
                     "items_per_page": ItemPerPages,
                     "search_value": vendorName]
        } else {
            param = ["page_no": pageNumber,
                     "items_per_page": ItemPerPages]
        }
        
        let apiCon = APIConfiguration(
            method: .get,
            base: URLCommand.host,
            path: URLCommand.products,
            parameters: param
        )
        
        let searchProductListAPI = SearchProductListAPI(configuration: apiCon)
        searchProductListAPI.execute { result in
            switch result {
            case .success(let data):
                self.productList.value = data.pages
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
