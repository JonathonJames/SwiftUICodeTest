//
//  Task.swift
//  everyLIFE_TechTest
//
//  Created by Jonathon James on 31/08/2021.
//

import Foundation
import GRDB


/// Describes a task which can be undertaken by the user.
struct Task: Codable {
    
    /// Describes a category to which a `Task` can belong.
    enum Category: String, Codable {
        case general
        case hydration
        case medication
        case nutrition
    }
    
    /// A unique identifier of the task.
    let id: Int64
    /// The human-readable name of the task.
    let name: String
    /// A human-readable description of the task.
    let description: String
    /// The `Category` to which this `Task` belongs.
    let type: Category
}

extension Task: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

/// Adds the ability for `Tasks` to be persisted and subsequently fetched via GRDB.
extension Task: AnyPersistable {}

protocol AnyPersistable: FetchableRecord & PersistableRecord {}


protocol PersistenceLayerInterface {
    func fetch<T: AnyPersistable>() throws -> [T]
    func insert<T: AnyPersistable>(_ persistables: T...) throws
    func update<T: AnyPersistable>(_ persistables: T...) throws
    func insertOrUpdate<T: AnyPersistable>(_ persistables: T...) throws
    
    func insert<T: Collection>(_ persistables: T) throws where T.Element: AnyPersistable
    func update<T: Collection>(_ persistables: T) throws where T.Element: AnyPersistable
    func insertOrUpdate<T: Collection>(_ persistables: T) throws where T.Element: AnyPersistable
}

final class GRDBDatabase {
    
    /// Connection to the underlying SQLite database.
    private let dbQueue: DatabaseQueue = {
        let retval: DatabaseQueue = try! .init(path: "/resources/database.sqlite")
        
        // Define the database schema
        try! retval.write { db in
            try! db.create(table: "tasks") { t in
                t.column("id", .integer).notNull()
                t.column("name", .text).notNull()
                t.column("description", .text).notNull()
                t.column("type", .text).notNull()
                t.primaryKey(["id"])
            }
        }
        
        return retval
    }()
}

extension GRDBDatabase: PersistenceLayerInterface {
    
    func fetch<T: AnyPersistable>() throws -> [T] {
        return try self.dbQueue.read { db in
            return try T.fetchAll(db)
        }
    }
    
    func insert<T: AnyPersistable>(_ persistables: T...) throws {
        try self.insert(persistables)
    }
    
    func update<T: AnyPersistable>(_ persistables: T...) throws {
        try self.update(persistables)
    }
    
    func insertOrUpdate<T: AnyPersistable>(_ persistables: T...) throws {
        try self.insertOrUpdate(persistables)
    }
    
    func insert<T: Collection>(_ persistables: T) throws where T.Element: AnyPersistable {
        try self.dbQueue.write({ db in
            try persistables.forEach { persistable in
                try persistable.insert(db)
            }
        })
    }
    
    func update<T: Collection>(_ persistables: T) throws where T.Element: AnyPersistable {
        try self.dbQueue.write({ db in
            try persistables.forEach { persistable in
                try persistable.update(db)
            }
        })
    }
    
    func insertOrUpdate<T: Collection>(_ persistables: T) throws where T.Element: AnyPersistable {
        try self.dbQueue.write({ db in
            try persistables.forEach { persistable in
                guard try persistable.exists(db) else {
                    try persistable.insert(db)
                    return
                }
                try persistable.update(db)
            }
        })
    }
}
