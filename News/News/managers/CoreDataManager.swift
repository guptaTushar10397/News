//
//  CoreDataManager.swift
//  News
//
//  Created by Tushar Gupta on 22/08/24.
//

import CoreData

protocol CoreDataManagerProtocol {
    func saveDocs(docsArray: [Docs])
    func fetchSavedDocs() -> [Docs]
}

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.persistentContainer = container
    }
}

extension CoreDataManager: CoreDataManagerProtocol {
    
    func saveDocs(docsArray: [Docs]) {
        for docs in docsArray {
            let cdDocs = CDDocs(context: persistentContainer.viewContext)
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
                abstract: cdDoc.abstract,
                multimedia: multimedia,
                pubDate: cdDoc.pubDate
            )
        }
    }
}
