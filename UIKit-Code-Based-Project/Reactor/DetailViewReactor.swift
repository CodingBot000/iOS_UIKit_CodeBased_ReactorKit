//
//  MainViewConReactor.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/14/24.
//

import ReactorKit
import RxSwift

class DetailViewReactor: Reactor {
    
    enum Action {
        case toggleLike
        case fetchData(String)
    }
    
    enum Mutation {
        case setLiked(Bool)
        case setProductData(ProductData?)
        
    }
    
    struct State {
        var isLiked: Bool
        var productData: ProductData?
    }
    
    let initialState: State
    let repository: ProductMapperRepository
    
    init(id: String) {
        repository = ProductMapperRepositoryImpl()
        
        self.initialState = State(isLiked: false, productData: nil)
        self.action.onNext(.fetchData(id))
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleLike:
            let newLikedState = !currentState.isLiked
            return Observable.just(Mutation.setLiked(newLikedState))
        case .fetchData(let id):
            return repository.fetchDatas(id: id)
                .flatMap { productData -> Observable<Mutation> in
                    MemoryStores.addProdcutHistory(prodcutData: productData)
                    return Observable.just(Mutation.setProductData(productData))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setLiked(let isLiked):
            newState.isLiked = isLiked
        case .setProductData(let productData):
            newState.productData = productData
        }
        return newState
    }
}
