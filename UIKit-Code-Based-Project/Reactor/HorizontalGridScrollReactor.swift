//
//  HorizontalGridScrollReactor.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import ReactorKit
import RxSwift

class HorizontalGridScrollReactor: Reactor {
    enum Action {
        case fetchDataList
    }
    
    enum Mutation {
        case setProducts([ProductData])
    }
    
    struct State {
        var products: [ProductData] = []
    }
    
    let initialState: State
    private let productRepository: ProductRepositoryProtocol
    
    
    init(productRepository: ProductRepositoryProtocol) {
        self.productRepository = productRepository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchDataList:
            return productRepository.fetchDatas()
                .map { Mutation.setProducts($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setProducts(let products):
            newState.products = products
        }
        return newState
    }
}
