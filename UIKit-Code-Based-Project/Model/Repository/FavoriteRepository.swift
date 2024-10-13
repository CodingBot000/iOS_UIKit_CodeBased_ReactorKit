//
//  FavoriteRepository.swift
//  Shopping
//
//  Created by switchMac on 8/25/24.
//

import Foundation

class FavoriteRepository {
    static let shared = FavoriteRepository()
    private let coreDataMgr = CoreDataManager.shared
    
    private init() {}
    
    func removeFavoriteDataById(id: String) {
        coreDataMgr.deleteItemById(id: id)
    }
    
    func getAllFavoriteData() -> [ProductData] {
        let favoriteDatas: [FavoriteEntity] = coreDataMgr.fetchAllFavorites()
        let productDatas = DataStores.getProductDatas()

        let favoriteIds = favoriteDatas.map { $0.id }
        let filteredProducts = productDatas.filter { favoriteIds.contains($0.id) }

        return filteredProducts
    }
    
    func getFavorite(id: String) -> FavoriteEntity? {
        return coreDataMgr.fetchFavoriteById(id: id)
    }
    
    func fetchAllFavorites() -> [FavoriteEntity]
    {
        return coreDataMgr.fetchAllFavorites()
    }
    
    func removeFavorite(id: String) {
        coreDataMgr.deleteItemById(id: id)
    }
    
    func addFavorite(id: String) {
        coreDataMgr.saveFavorite(id: id)
    }
}
