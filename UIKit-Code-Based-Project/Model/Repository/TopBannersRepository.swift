//
//  TopBannersRepository.swift
//  Shopping
//
//  Created by switchMac on 8/24/24.
//

import RxSwift

protocol TopBannersRepository: ImageSldiderRepositoryProtocol {
    func fetchDatas() -> Observable<[ImageSliderData]>
}


class TopBannersRepositoryImpl: TopBannersRepository {

    func fetchDatas() -> Observable<[ImageSliderData]> {
        let dataList = DataStores.getTopBannerDatas()
        
        return Observable.just(dataList)
    
    }
}

