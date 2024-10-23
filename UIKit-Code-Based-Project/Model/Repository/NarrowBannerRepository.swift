//
//  NarrowBannerRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/24/24.
//

import RxSwift


protocol NarrowBannerRepository {
    func fetchBanners() -> Observable<[NarrowBannerData]>
}

class NarrowBannerRepositoryImpl: NarrowBannerRepository {
    func fetchBanners() -> Observable<[NarrowBannerData]> {
        let dataList = DataStores.getNarrowBannerDatas()
        
        return Observable.just(dataList)
    
    }
}
