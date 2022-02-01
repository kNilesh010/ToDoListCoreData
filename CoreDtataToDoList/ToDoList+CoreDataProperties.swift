//
//  ToDoList+CoreDataProperties.swift
//  ToDoList
//
//  Created by Nilesh Kumar on 31/01/22.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var itemName: String?
    @NSManaged public var createdDate: Date?

}

extension ToDoList : Identifiable {

}
