//
//  RecommendRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import RxSwift

protocol RecommendRepository: ProductRepositoryProtocol {
    func fetchDatas() -> Observable<[ProductData]>
}

class RecommendRepositoryImpl: RecommendRepository {
    func fetchDatas() -> Observable<[ProductData]> {
        let dataList = DataStores.getDisplayItemDatas(limit: 11)
        
        return Observable.just(dataList)
    }
}
