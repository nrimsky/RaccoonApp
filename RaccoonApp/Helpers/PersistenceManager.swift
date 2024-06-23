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
    
    func saveData(data: AppState) throws {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let text = data.toJson() else {
            throw PersistenceError.other
        }
        
        let tempFileUrl = dir.appendingPathComponent(fileName + ".temp")
        let fileUrl = dir.appendingPathComponent(fileName)
        
        do {
            try text.write(to: tempFileUrl, atomically: true, encoding: .utf8)
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                try FileManager.default.removeItem(at: fileUrl)
            }
            try FileManager.default.moveItem(at: tempFileUrl, to: fileUrl)
            print("Data saved successfully")
        } catch {
            print("Error saving data: \(error)")
            throw error
        }
    }
    
    func getData() throws -> AppState {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    let data = try Data(contentsOf: fileURL)
                    let res = try Helpers.decoder.decode(AppState.self, from: data)
                    return res
                } catch {
                    print("Error decoding data: \(error)")
                    throw PersistenceError.noData
                }
            } else {
                print("No existing data file found")
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
