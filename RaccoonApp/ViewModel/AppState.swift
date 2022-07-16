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
    @Published var habitsToShow: [Habit] = []
    @Published var viewingDate: Date = Date()
    
    private var habitsToShowPublisher: AnyPublisher<[Habit],Never> {
        Publishers.CombineLatest($habits, $viewingDate).map { habits, date in
            return habits.filter {
                $0.show(on: date)
            }
        }.eraseToAnyPublisher()
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        habitsToShowPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.habitsToShow, on: self)
            .store(in: &subscriptions)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        habits = try values.decode([Habit].self, forKey: .habits)
        habitsToShowPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.habitsToShow, on: self)
            .store(in: &subscriptions)
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
