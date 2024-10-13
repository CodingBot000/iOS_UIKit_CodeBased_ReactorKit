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
        case loadData
    }
    
    enum Mutation {
        case setLiked(Bool)
        case setProductData(ProductData)
    }
    
    struct State {
        var isLiked: Bool
        var productData: ProductData
    }
    
    let initialState: State
    
    init(productData: ProductData) {
        self.initialState = State(isLiked: false, productData: productData)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleLike:
            let newLikedState = !currentState.isLiked
            return Observable.just(Mutation.setLiked(newLikedState))
        case .loadData:
            MemoryStores.addProdcutHistory(prodcutData: currentState.productData)
            return Observable.just(Mutation.setProductData(currentState.productData))
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
