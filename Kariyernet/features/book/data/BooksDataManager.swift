//
//  BooksDataManager.swift
//  Kariyernet
//
//  Created by Canberk Çakmak on 6.02.2025.
//

import CoreData
import Combine

final class BooksDataManager {
    static let shared = BooksDataManager()
    let favoritesPublisher = PassthroughSubject<Void, Never>()
    
    private init() {
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data store error: \(error)")
            }
        }
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Books")
        return container
    }()
    
    private var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Context error: \(error)")
        }
    }
    
    func saveFavorite(_ book: Book) {
        let favoriteEntity = NSEntityDescription.insertNewObject(forEntityName: "FavoriteBook", into: context)
        
        favoriteEntity.setValue(book.id, forKey: "id")
        favoriteEntity.setValue(book.name, forKey: "name")
        favoriteEntity.setValue(book.artistName, forKey: "artistName")
        favoriteEntity.setValue(book.releaseDate, forKey: "releaseDate")
        favoriteEntity.setValue(book.artworkUrl100, forKey: "artworkUrl")
        favoriteEntity.setValue(book.kind, forKey: "kind")
        favoriteEntity.setValue(book.artistId, forKey: "artistId")
        favoriteEntity.setValue(book.artistUrl, forKey: "artistUrl")
        favoriteEntity.setValue(book.url, forKey: "url")
        
        saveContext()
        favoritesPublisher.send()
    }
    
    func deleteFavorite(_ id: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteBook")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            saveContext()
            favoritesPublisher.send()
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    func getFavoriteBooks() -> [Book] {
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "FavoriteBook")
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.compactMap { favoriteBook -> Book? in
                guard let id = favoriteBook.value(forKey: "id") as? String,
                      let name = favoriteBook.value(forKey: "name") as? String,
                      let artistName = favoriteBook.value(forKey: "artistName") as? String,
                      let releaseDate = favoriteBook.value(forKey: "releaseDate") as? String,
                      let artworkUrl100 = favoriteBook.value(forKey: "artworkUrl") as? String,
                      let kind = favoriteBook.value(forKey: "kind") as? String,
                      let artistId = favoriteBook.value(forKey: "artistId") as? String,
                      let artistUrl = favoriteBook.value(forKey: "artistUrl") as? String,
                      let url = favoriteBook.value(forKey: "url") as? String else {
                    return nil
                }
                
                return Book(
                    artistName: artistName,
                    id: id,
                    name: name,
                    releaseDate: releaseDate,
                    kind: kind,
                    artistId: artistId,
                    artistUrl: artistUrl,
                    artworkUrl100: artworkUrl100,
                    url: url,
                    contentAdvisoryRating: nil
                )
            }
        } catch {
            print("Favorite list errır: \(error)")
            return []
        }
    }
    
    func isFavorite(_ id: String) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteBook")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
}
