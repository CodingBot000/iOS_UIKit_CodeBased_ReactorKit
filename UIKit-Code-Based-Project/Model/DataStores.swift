//
//  DataStores.swift
//  Shopping
//
//  Created by switchMac on 8/23/24.
//

import Foundation

final class DataStores {
    private static var productDatas: [ProductData] = []  
    
    static func getProductDatas() -> [ProductData] {
        return buidProductDatas()
    }
    
    private static func buidProductDatas() -> [ProductData] {
        let loadedData: [ProductData] = loadJson("productDataJson.json")
        productDatas = loadedData
        return productDatas
    }
    
    static func getBannerDatas() -> [ProductData] {
        let bannerIDData: BannerData = loadJson("bannerDataJson.json")
        let bannerIDs = bannerIDData.ids
        let bannerDatas = buidProductDatas().filter { bannerIDs.contains($0.id) }
      
        return bannerDatas
    }

    static func getNarrowBannerDatas() -> [NarrowBannerData] {
        let narrowBannerDatas: [NarrowBannerData] = loadJson("narrowBannerDataJson.json")
        return narrowBannerDatas
    }

    
    static func getProductDataByID(id: String) -> [ProductData] {
        let productData = buidProductDatas().filter { id.contains($0.id) }
     
        return productData
    }
    
    static func getChipDatas() -> [ChipData] {
        return loadJson("chipDataJson.json")
    }
    
    static func getDisplayItemDatas(limit :Int = 0) -> [ProductData] {
        let displayItems = buidProductDatas().shuffled()
        return limit > 0 ? Array(displayItems.prefix(limit)) : displayItems
    }
}



