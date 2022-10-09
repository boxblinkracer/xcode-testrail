//
//  Resource.swift
//
//  Copyright © 2022 Christian Dangl. All rights reserved.
//

import Foundation


class Resource {

    static var resourcePath = "./"

    let name: String
    let type: String

    init(name: String, type: String) {
        self.name = name
        self.type = type
    }

    var path: String {
        guard let path: String = Bundle(for: Swift.type(of: self)).path(forResource: name, ofType: type) else {
            let filename: String = type.isEmpty ? name : "\(name).\(type)"
            return "\(Resource.resourcePath)/\(filename)"
        }
        return path
    }

    var content: String? {
            return try? String(contentsOfFile: path).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
}