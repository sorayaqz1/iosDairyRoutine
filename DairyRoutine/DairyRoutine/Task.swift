//
//  Task.swift
//  Hello World
//
//  Created by Qing Zhang on 5/21/18.
//  Copyright © 2018 Qing Zhang. All rights reserved.
//

import UIKit
import os.log

class Task: NSObject, NSCoding {
    
    // MARK: properties
    var name: String
    var photo: UIImage?
    var desc: String
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("tasks")
    
    
    // MARK; Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let desc = "description"
    }
    
    
    init?(name: String, photo: UIImage, desc: String) {
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.desc = desc
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(desc, forKey: PropertyKey.desc)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required.  If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for a Task object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let desc = aDecoder.decodeObject(forKey: PropertyKey.desc)
        
        // must call designated initializer.
        self.init(name: name, photo: photo!, desc: desc as! String)
        
    }
    
    
}
