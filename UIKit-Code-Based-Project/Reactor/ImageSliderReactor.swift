//
//  ImageSliderReactor.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/7/24.
//
import ReactorKit
import RxSwift

class ImageSliderReactor: Reactor {

    enum Action {
        case nextImage
        case previousImage
        case fetchImages
    }
    
    enum Mutation {
        case setSliderDatas([ImageSliderData])
        case setCurrentIndex(Int)
    }
    
    struct State {
        var datas: [ImageSliderData] = []
        var currentIndex: Int = 0
    }
    
    let initialState: State
    private let imageSliderRepository: ImageSldiderRepositoryProtocol
    
    init(imageSliderRepository: ImageSldiderRepositoryProtocol) {
        self.imageSliderRepository = imageSliderRepository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextImage:
            var newIndex = currentState.currentIndex + 1
            if newIndex >= currentState.datas.count {
                newIndex = 0
            }
            return Observable.just(Mutation.setCurrentIndex(newIndex))
            
        case .previousImage:
            var newIndex = currentState.currentIndex - 1
            if newIndex < 0 {
                newIndex = self.currentState.datas.count - 1
            }
            return Observable.just(Mutation.setCurrentIndex(newIndex))
            
        case .fetchImages:
            return imageSliderRepository.fetchDatas()
                .map { Mutation.setSliderDatas($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            case .setSliderDatas(let producDatas):
                newState.datas = producDatas
            case .setCurrentIndex(let index):
                newState.currentIndex = index
        }
        return newState
    }
}
