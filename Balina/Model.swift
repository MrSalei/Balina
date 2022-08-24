//
//  Model.swift
//  Balina
//
//  Created by luqrri on 24.08.22.
//

import Foundation

struct Welcome: Codable {
    let content: [Content]
    let page, pageSize, totalElements, totalPages: Int
}

struct Content: Codable {
    let id: Int
    let name, image: String?
}
