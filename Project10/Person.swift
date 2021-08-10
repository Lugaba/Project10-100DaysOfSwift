//
//  Person.swift
//  Project10
//
//  Created by Luca Hummel on 04/08/21.
//

import UIKit

//class Person: NSObject, NSCoding {
//    var name: String
//    var image: String
//
//    init(name: String, image: String) {
//        self.name = name
//        self.image = image
//    }
//
//    required init?(coder: NSCoder) {
//        name = coder.decodeObject(forKey: "name") as? String ?? ""
//        image = coder.decodeObject(forKey: "image") as? String ?? ""
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(name, forKey: "name")
//        coder.encode(image, forKey: "image")
//    }
//}

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
