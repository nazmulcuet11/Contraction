//
//  DBMigrator.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

import Foundation

final class DBMigrator {

    private let userDefaults = UserDefaults.standard

    // TODO: - Read from config file
    private let targetDBSchemaVersion: Int = 1

    private var migrations: [Int: DBMigration] = [:]

    func migrate() async throws {
        loadMigrations()

        while currntVersion() < targetDBSchemaVersion {
            if let migration = migrations[currntVersion()] {
                try await migration.migrate()
                updateCurrentVersion(migration.destinationSchemaVersion)
            } else {
                fatalError("Unknown migration version \(currntVersion())")
            }
        }
    }

    // TODO: - Read from config file
    private func loadMigrations() {
        let migrations = [
            DBMigration0to1()
        ]

        for migration in migrations {
            self.migrations[migration.sourceSchemaVersion] = migration
        }
    }

    private func currntVersion() -> Int {
        userDefaults.integer(forKey: UserDefaultsKeys.dbSchemaVersion)
    }

    private func updateCurrentVersion(_ version: Int) {
        userDefaults.set(version, forKey: UserDefaultsKeys.dbSchemaVersion)
    }
}
