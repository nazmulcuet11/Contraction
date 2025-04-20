//
//  AppDelegate.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

final class Application {
    let migrator = DBMigrator()
    let contractionRecordRepository = ContractionRecordRealmRepository()
    
    private init() {}

    static let shared = Application()
}
