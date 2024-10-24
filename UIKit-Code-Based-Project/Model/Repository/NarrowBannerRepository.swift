//
//  NarrowBannerRepository.swift
//  UIKit-Code-Based-Project
//
//  Created by switchMac on 10/24/24.
//

import RxSwift

protocol NarrowBannerRepository: ImageSldiderRepositoryProtocol {
    func fetchDatas() -> Observable<[ImageSliderData]>
}

class NarrowBannerRepositoryImpl: NarrowBannerRepository {
    func fetchDatas() -> Observable<[ImageSliderData]> {
        let dataList = DataStores.getNarrowBannerDatas()
        
        return Observable.just(dataList)
    
    }
}
