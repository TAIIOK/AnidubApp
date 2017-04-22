//
//  globalfunctions.swift
//  Vstu
//
//  Created by Roman Efimov on 18.02.17.
//  Copyright © 2017 Roman Efimov. All rights reserved.
//

import Foundation
import SQLite


func saveStudent(){
    var path = getPath(fileName: "appdatabase.sqlite")
    
    let db = try! Connection(getPath(fileName: "appdatabase.sqlite"))
    let student = Table("Student")
    
    let id = Expression<Int>("id")
    let Recordbook = Expression<Int>("Recordbook")
    let Group = Expression<String?>("Group")
    let Name = Expression<String>("Name")
    let Surname = Expression<String>("Surname")
    let Middlename = Expression<String>("Middlename")
    
    
   // let insert = student.insert(id <- value.id, Recordbook <- value.RecordBook, Group <- value.Group, Name <- value.Name, Surname <- value.Surname, Middlename <- value.MiddleName)
    //let rowid = try! db.run(insert)
}

func removeStudent(){
    let db = try! Connection(getPath(fileName: "appdatabase.sqlite"))
    let student = Table("Student")
    
    let alice = student.filter(1 == rowid)
    
    try! db.run(alice.delete())

    
}

func loadStudent() -> Any? {
    let db = try! Connection(getPath(fileName: "appdatabase.sqlite"))
    let student = Table("Student")
    
    let id = Expression<Int>("id")
    let Recordbook = Expression<Int>("Recordbook")
    let Group = Expression<String?>("Group")
    let Name = Expression<String>("Name")
    let Surname = Expression<String>("Surname")
    let Middlename = Expression<String>("Middlename")
    
    for student in try! db.prepare(student) {
        let id = student.get(id)
        let name =  student.get(Name)
        let surname =  student.get(Surname)
        let middlename =  student.get(Middlename)
        let group = student.get(Group)
        let recordbook = student.get(Recordbook)
        // id: 1, email: alice@mac.com, name: Optional("Alice")
        return nil // Student(id: id, Name: name, Surname: surname, MiddleName: middlename, Group: group!, RecordBook: recordbook)
    }
    
    return nil
    
}
func getPath(fileName: String) -> String {
    let documentsURL = NSURL(
        fileURLWithPath: NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first!,
        isDirectory: true
    )
    
    let fileURL = documentsURL.appendingPathComponent(fileName)
    
    var fileSize : UInt64 = 1
    
    do {
        //return [FileAttributeKey : Any]
        let attr = try FileManager.default.attributesOfItem(atPath: (fileURL?.path)!)
        fileSize = attr[FileAttributeKey.size] as! UInt64
        
        //if you convert to NSDictionary, you can get file size old way as well.
        let dict = attr as NSDictionary
        fileSize = dict.fileSize()
    } catch {
        print("Error: \(error)")
    }
    if(fileSize == 1)
    {
        print("fail")
        return ""
    }
    
    return fileURL!.path
}

func copyFile(fileName: NSString) {
    
    let fileManager = FileManager.default
    let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
    let destinationSqliteURL = documentsPath.appendingPathComponent("appdatabase.sqlite")
    let sourceSqliteURL = Bundle.main.url(forResource: "appdatabase", withExtension: "sqlite")
    
    if !fileManager.fileExists(atPath: destinationSqliteURL!.path) {
        // var error:NSError? = nil
        do {
            try fileManager.copyItem(at: sourceSqliteURL!, to: destinationSqliteURL!)
            print("Copied")
            print(destinationSqliteURL?.path)
        } catch let error as NSError {
            print("Unable to create database \(error.debugDescription)")
        }
    }
}

