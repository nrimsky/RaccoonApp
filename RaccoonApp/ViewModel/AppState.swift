//
//  AppState.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import Combine
import Foundation

enum PersistanceError: Error {
    case noData
    case other
}

class AppState: ObservableObject, Codable {
    
    static let persistFilename = "appState.json"
    
    @Published var habits: [Habit] = []
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        habits = Helpers.mockHabits()
        for habit in habits {
            habit.objectWillChange
                .sink(receiveValue: { [weak self] in self?.objectWillChange.send() })
                .store(in: &subscriptions)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        habits = try values.decode([Habit].self, forKey: .habits)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(habits, forKey: .habits)
    }
    
    func add(habit: Habit) {
        habits.append(habit)
        habit.objectWillChange
            .sink(receiveValue: { [weak self] in self?.objectWillChange.send() })
            .store(in: &subscriptions)
        try? persist()
    }
    
    func delete(habit: Habit) {
        habits.removeAll(where: {$0.id == habit.id})
        try? persist()
    }
    
    enum CodingKeys: String, CodingKey {
        case habits
    }
        
    func persist() throws {
        try Helpers.persistenceManager.saveData(data: self)
    }
    
    static func load() throws -> AppState {
        return try Helpers.persistenceManager.getData()
    }
    
 }
