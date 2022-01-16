//
//  Model.swift
//  FindSimilarCelebrities
//
//  Created by 유준용 on 2021/09/25.
//

import CoreData
import Foundation
import UIKit



class DataManager{
  static let shared = DataManager()
  private init(){
  }
  var mainContext : NSManagedObjectContext{
    return persistentContainer.viewContext
  }
    var recordList = [Record]()
      
    func fetchRecord() {
        let request : NSFetchRequest<Record> = Record.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key : "date", ascending : false)
        request.sortDescriptors = [sortByDateDesc]
        do{
            try recordList = mainContext.fetch(request)
        }catch{
            print(error)
        }
      }
    
    func addNewRecord(_ record: [String:String], _ img: Data){
        
      let newRecord = Record(context : mainContext)
        newRecord.image = img
        newRecord.date = Date()
        newRecord.celebrityValue = record["celebrityValue"]
        newRecord.celebrityConfidence = record["celebrityConfidence"]
        newRecord.faceGenderValue = record["genderValue"]
        newRecord.faceGenderConfidence = record["genderConfidence"]
        newRecord.faceAgeValue = record["ageValue"]
        newRecord.faceAgeConfidence = record["ageConfidence"]
        newRecord.facePoseConfidence = record["poseConfidence"]
        newRecord.facePoseValue = record["poseValue"]
        newRecord.faceEmotionValue = record["emotionValue"]
        newRecord.faceEmotionConfidence = record["emotionConfidence"]
        saveContext()
        fetchRecord()
    }
    
    func delRecord(_ record: Record?){
        if let record = record{
            mainContext.delete(record)
            saveContext()
            fetchRecord()
        }
    }
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FindSimilarCelebrities")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
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
}
