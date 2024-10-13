//
//  CoreDataManager.swift
//  Shopping
//
//  Created by switchMac on 8/25/24.
//


import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Favorite")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func deleteItemById(id: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                if let objectToDelete = object as? NSManagedObject {
                    context.delete(objectToDelete)
                }
            }
            saveContext() // Save the context after deleting
        } catch let error as NSError {
            print("Error deleting item with id \(id): \(error), \(error.userInfo)")
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveFavorite(id: String) {
        let coreDataMgr = CoreDataManager.shared
        let context = coreDataMgr.context
        
        
        let entity = FavoriteEntity(context: context)
        entity.id = id
        
        do {
            try context.save()
        } catch {
            print("Failed to save articles: \(error.localizedDescription)")
        }
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print("Error deleting all data: \(error), \(error.userInfo)")
        }
    }
    
    func fetchAllFavorites() -> [FavoriteEntity] {
            let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
            
            do {
                let results = try context.fetch(fetchRequest)
                print(results)
                return results
            } catch let error as NSError {
                print("Error fetching all favorites: \(error), \(error.userInfo)")
                return []
            }
        }

       
    func fetchFavoriteById(id: String) -> FavoriteEntity? {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Return the first result, if any
        } catch let error as NSError {
            print("Error fetching favorite with id \(id): \(error), \(error.userInfo)")
            return nil
        }
    }
}
