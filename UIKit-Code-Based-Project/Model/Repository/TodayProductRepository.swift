//
//  TodayProductRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//

import RxSwift

protocol TodayProductRepository: ProductCommonRepository {
    func fetchDatas() -> Observable<[ProductData]>
}

class TodayProductRepositoryImpl: TodayProductRepository {
    func fetchDatas() -> Observable<[ProductData]> {
     
        let dataList = DataStores.getDisplayItemDatas(limit: 7)
        
        return Observable.just(dataList)
    }
}
