//
//  ToDoItem.swift
//  Verify
//
//  Created by Razvan Julian on 16/07/15.
//  Copyright (c) 2015 Razvan Julian. All rights reserved.
//

import Foundation
import UIKit

class ToDoItem: NSObject, NSCoding {
    
    // MARK: Properties
    
    var title: String
    var note: String
    var location: String
    var deadline: Date
    
    //var UUID: String
    
    
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todoItems")
    
    

    
    // MARK: Types
    
    struct PropertyKey {
        static let titleKey = "title"
        static let noteKey = "note"
        static let locationKey = "location"
        static let deadlineKey = "deadline"
        //static let UUIDKey = "UUID"
    }
    
    
    // MARK: Initialization
    
    init?(deadline: Date, note: String, location: String, title: String){//, UUID: String) {
        self.title = title
        self.deadline = deadline
        self.note = note
        self.location = location
        //self.UUID = UUID
        
        super.init()
        
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty {
            return nil
        }
    }
    
    var isOverdue: Bool {
        return (Date().compare(self.deadline) == ComparisonResult.orderedDescending) // deadline is earlier than current date
    }
    
    
    
    
    
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: PropertyKey.titleKey)
        aCoder.encode(note, forKey: PropertyKey.noteKey)
        aCoder.encode(location, forKey: PropertyKey.locationKey)
        aCoder.encode(deadline, forKey: PropertyKey.deadlineKey)
        //aCoder.encodeObject(UUID, forKey: PropertyKey.UUIDKey)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: PropertyKey.titleKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let deadline = aDecoder.decodeObject(forKey: PropertyKey.deadlineKey) as! Date
        
        let note = aDecoder.decodeObject(forKey: PropertyKey.noteKey) as! String
        
        let location = aDecoder.decodeObject(forKey: PropertyKey.locationKey) as! String
        //let UUID = aDecoder.decodeObjectForKey(PropertyKey.UUIDKey) as! String
        
        // Must call designated initializer.
        self.init( deadline: deadline, note: note, location: location, title: title)//), UUID: UUID )
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}
