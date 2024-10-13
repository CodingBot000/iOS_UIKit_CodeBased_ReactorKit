//
//  BannersRepository.swift
//  Shopping
//
//  Created by switchMac on 8/24/24.
//

import RxSwift


protocol BannersRepository {
    func fetchBanners() -> Observable<[ProductData]>
}

class BannersRepositoryImpl: BannersRepository {
    func fetchBanners() -> Observable<[ProductData]> {
        let dataList = DataStores.getBannerDatas()
        
        return Observable.just(dataList)
    
    }
}

