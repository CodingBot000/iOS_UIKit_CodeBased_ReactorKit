//
//  GenreRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/11/24.
//

import RxSwift

protocol GenreRepository: ProductRepositoryProtocol {
    func fetchDatas() -> Observable<[ProductData]>
}

class GenreRepositoryImpl: TodayProductRepository {
    func fetchDatas() -> Observable<[ProductData]> {
     
        let dataList = DataStores.getDisplayItemDatas(limit: 5)
        
        return Observable.just(dataList)
    }
}
