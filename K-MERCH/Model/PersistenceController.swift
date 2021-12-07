//
//  PersistenceController.swift
//  K-MERCH
//
//  Created by Arrinal Sholifadliq on 02/12/21.
//

//import CoreData
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    let container: NSPersistentContainer
//
//    init() {
//        container = NSPersistentCloudKitContainer(name: "KmerchDataModel")
//        container.loadPersistentStores { (description, error) in
//            if let error = error {
//                fatalError("Error: \(error.localizedDescription)")
//            }
//        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//    }
//    
//
//    func save(completion: @escaping (Error?) -> () = {_ in}) {
//        let context = container.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//                completion(nil)
//            } catch {
//                completion(error)
//            }
//        }
//    }
//    
//    func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}) {
//        let context = container.viewContext
//        context.delete(object)
//        save(completion: completion)
//    }
//}
