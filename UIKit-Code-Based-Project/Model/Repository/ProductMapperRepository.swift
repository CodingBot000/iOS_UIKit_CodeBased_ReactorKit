//
//  ProductMapperRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/24/24.
//

import RxSwift

protocol ProductMapperRepository {
    func fetchDatas(id: String) -> Observable<ProductData?>
}

class ProductMapperRepositoryImpl: ProductMapperRepository {
    func fetchDatas(id: String) -> Observable<ProductData?> {
        let productData = DataStores.getProductDataByID(id: id)
        return Observable.just(productData)
    }
}
