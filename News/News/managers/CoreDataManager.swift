//
//  CoreDataManager.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import CoreData
import UIKit

protocol CoreDataManagerProtocol: AnyObject {
    func addObserver(_ observer: CoreDataManagerToInteractorProtocol)
    func removeObserver(_ observer: CoreDataManagerToInteractorProtocol)
}

protocol CoreDataManagerToInteractorProtocol: AnyObject {
    func coreDataManagerDidSuccessfullyDeletedDoc(_ doc: Docs)
    func coreDataManagerDidSuccessfullyUpdateDoc(_ doc: Docs)
}

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    var interactors: [CoreDataManagerToInteractorProtocol] = []
    
    private init () {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.persistentContainer = appDelegate.persistentContainer
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    func addObserver(_ observer: CoreDataManagerToInteractorProtocol) {
        if !interactors.contains(where: {$0 === observer} ) {
            interactors.append(observer)
        }
    }
    
    func removeObserver(_ observer: CoreDataManagerToInteractorProtocol) {
        guard let index = interactors.firstIndex(where: {$0 === observer}) else { return }
        interactors.remove(at: index)
    }
    
    func saveDocs(docsArray: [Docs]) {
        for docs in docsArray {
            let cdDocs = CDDocs(context: persistentContainer.viewContext)
            cdDocs.id = docs.id
            cdDocs.isFavourite = docs.isFavourite
            cdDocs.abstract = docs.abstract
            cdDocs.pubDate = docs.pubDate

            if let multimediaArray = docs.multimedia {
                for multimediaObject in multimediaArray {
                    let multimedia = CDMultimedia(context: persistentContainer.viewContext)
                    multimedia.iconUrl = multimediaObject.url
                    cdDocs.addToMultimedia(multimedia)
                }
            }
        }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save data: \(error)")
        }
    }

    func fetchSavedDocs() -> [Docs] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDDocs> = CDDocs.fetchRequest()
        
        guard let cdDocs = try? context.fetch(fetchRequest) else { return [] }
        
        return cdDocs.map { cdDoc in
            // Map multimedia
            let multimedia = (cdDoc.multimedia as? Set<CDMultimedia>)?.compactMap { cdMultimedia in
                return Multimedia(url: cdMultimedia.iconUrl)
            }
            
            // Map headline
            return Docs(
                id: cdDoc.id,
                abstract: cdDoc.abstract,
                multimedia: multimedia,
                pubDate: cdDoc.pubDate,
                isFavourite: cdDoc.isFavourite
            )
        }
    }
    
    func delete(_ doc: Docs) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDDocs> = CDDocs.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [doc.id])
        
        do {
            let results = try context.fetch(fetchRequest)
            if let cdDocToDelete = results.first {
                context.delete(cdDocToDelete)
                do {
                    try persistentContainer.viewContext.save()
                    
                    interactors.forEach { object in
                        object.coreDataManagerDidSuccessfullyDeletedDoc(doc)
                    }
                    
                } catch {
                    print("Failed to save data: \(error)")
                }
                
            } else {
                print(" Doc is not exist.")
            }
            
        } catch {
            
        }
    }
    
    func updateDoc(_ doc: Docs) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<CDDocs> = CDDocs.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [doc.id])
        
        do {
            let results = try context.fetch(fetchRequest)
            if let cdDocToUpdate = results.first {
                cdDocToUpdate.isFavourite = doc.isFavourite
                do {
                    try persistentContainer.viewContext.save()
                    
                    interactors.forEach { object in
                        object.coreDataManagerDidSuccessfullyUpdateDoc(doc)
                    }
                    
                } catch {
                    print("Failed to save data: \(error)")
                }
                
            } else {
                print(" Doc is not exist.")
            }
            
        } catch {
            
        }
    }
}
