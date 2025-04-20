//
//  ContractionRecordRepository.swift
//  Contraction
//
//  Created by Nazmul Islam on 4/20/25.
//

protocol ContractionRecordRepositoryDelegate: AnyObject {
    func didAddRecord(_ record: ContractionRecord) async
}

protocol ContractionRecordRepository {
    func setDelegate(_ delegate: ContractionRecordRepositoryDelegate?)
    func fetchRecords() async throws -> [ContractionRecord]
    func addRecord(_ record: ContractionRecord) async throws
}
