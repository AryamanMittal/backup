//
//  searchModel.swift
//  QuickReturn
//
//  Created by aryaman mittal on 14/10/23.
//

import Foundation
class Searchname: Codable {
    let name: String

    init(name: String) {
        self.name = name
    }
}
class Search: Codable {
    let success: Bool
    let data: [Datum]
    let message: String

    init(success: Bool, data: [Datum], message: String) {
        self.success = success
        self.data = data
        self.message = message
    }
}

// MARK: - Datum
class Datum: Codable {
    let id, name, author: String
    let price, pages, available, total: Int
    let description: String
    let books: [String]
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, author, price, pages, available, total, description, books
        case v = "__v"
    }

    init(id: String, name: String, author: String, price: Int, pages: Int, available: Int, total: Int, description: String, books: [String], v: Int) {
        self.id = id
        self.name = name
        self.author = author
        self.price = price
        self.pages = pages
        self.available = available
        self.total = total
        self.description = description
        self.books = books
        self.v = v
    }
}
