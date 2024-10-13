//
//  HotNewsRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/8/24.
//


import RxSwift

protocol HotNewsRepository: ProductCommonRepository {
    func fetchDatas() -> Observable<[ProductData]>
}

class HotNewsRepositoryImpl: HotNewsRepository {
    func fetchDatas() -> Observable<[ProductData]> {
     
        let dataList = DataStores.getDisplayItemDatas(limit: 9)
        
        return Observable.just(dataList)
    }
}

