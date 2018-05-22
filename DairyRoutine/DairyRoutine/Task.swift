//
//  Task.swift
//  Hello World
//
//  Created by Qing Zhang on 5/21/18.
//  Copyright © 2018 Qing Zhang. All rights reserved.
//

import UIKit

class Task {
    
    var name: String
    var photo: UIImage?
    var desc: String
    
    init?(name: String, photo: UIImage, desc: String) {
        guard !name.isEmpty else {
            return nil
        }
        
        guard !desc.isEmpty else {
            return nil
        }
        
        
        self.name = name
        self.photo = photo
        self.desc = desc
    }
}
