//
//  PersistenceManager.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 15/07/2022.
//

import Foundation

enum PersistenceError: Error {
    case noData
    case other
}

struct PersistenceManager {
    
    let fileName = "appData.json"
    let jsonEncoder = JSONEncoder()
    let jsonDecoder = JSONDecoder()
    
    func saveData(data: AppState) throws {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let jsonData = try? jsonEncoder.encode(data), let text = String(data: jsonData, encoding: .utf8) {
            let fileUrl = dir.appendingPathComponent(fileName)
            try? deleteData()
            do {
                try text.write(to: fileUrl, atomically: false, encoding: .utf8)
                return
            } catch {
                throw PersistenceError.other
            }
        }
        throw PersistenceError.other
    }
    
    func getData() throws -> AppState {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            do {
                let data = try Data(contentsOf: fileURL)
                let res = try jsonDecoder.decode(AppState.self, from: data)
                return res
            } catch {
                throw PersistenceError.noData
            }
        }
        throw PersistenceError.other
    }
    
    private func deleteData() throws {
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,includingPropertiesForKeys: nil,options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for fileURL in fileURLs {
                if fileURL.relativeString.contains(fileName) {
                    try FileManager.default.removeItem(at: fileURL)
                    return
                }
            }
            
        }
    }
    
}
