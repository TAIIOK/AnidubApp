//
//  globalfunctions.swift
//  Vstu
//
//  Created by Roman Efimov on 18.02.17.
//  Copyright © 2017 Roman Efimov. All rights reserved.
//

import Foundation
import SQLite

/*
 var ID:Int
 var favCount:Int
 var username:String
 var password:String
*/
func saveUser(value: user){
    var path = getPath(fileName: "appdatabase.sqlite")
    
    let db = try! Connection(getPath(fileName: "appdatabase.sqlite"))
    let user = Table("User")
    
    let id = Expression<Int>("id")
    let favcount = Expression<Int>("favcount")
    let username = Expression<String?>("username")
    let password = Expression<String>("password")
    
    
    let insert = user.insert(id <- value.ID, favcount <- value.favCount, username <- value.username, password <- value.password)
    let rowid = try! db.run(insert)
}

func removeUser(){
    let db = try! Connection(getPath(fileName: "appdatabase.sqlite"))
    let user = Table("User")
    
    let alice = user.filter(1 == rowid)
    
    try! db.run(alice.delete())
    
}

func loadUser() -> Any? {
    let db = try! Connection(getPath(fileName: "appdatabase.sqlite"))
    let userT = Table("User")
    
    let id = Expression<Int>("id")
    let favcount = Expression<Int>("favcount")
    let username = Expression<String?>("username")
    let password = Expression<String>("password")
    
    for userR in try! db.prepare(userT) {

        return  user(ID: userR.get(id), favCount: userR.get(favcount), username: userR.get(username)!, password: userR.get(password))
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

