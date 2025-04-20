//
//  DBMigration.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import RealmSwift

protocol DBMigration {
    var sourceSchemaVersion: Int { get }
    var destinationSchemaVersion: Int { get }
    func migrate() async throws
}
