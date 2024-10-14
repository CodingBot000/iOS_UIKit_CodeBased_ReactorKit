//
//  ChipsSelectionReactor.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/12/24.
//


import ReactorKit
import RxSwift

class ChipsSelectionReactor: Reactor {
    enum Action {
        case fetchDataList
    }
    
    enum Mutation {
        case setDatas([ChipData])
    }
    
    struct State {
        var datas: [ChipData] = []
    }
    
    let initialState: State
    private let PointListRepository: PointListRepository
    
    
    init(PointListRepository: PointListRepository) {
        self.PointListRepository = PointListRepository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchDataList:
            return PointListRepository.fetchDatas().map { Mutation.setDatas($0) }
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setDatas(let datas):
            newState.datas = datas
        }
        return newState
    }
}
