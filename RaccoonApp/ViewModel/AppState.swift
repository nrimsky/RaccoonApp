//
//  AppState.swift
//  RaccoonApp
//
//  Created by Nina Rimsky on 14/07/2022.
//

import Combine
import Foundation

enum AppError: Error, Identifiable {
    case deletionFailed
    case persistenceFailed
    case loadingFailed
    
    var id: String { UUID().uuidString } // This makes it Identifiable
    
    var message: String {
        switch self {
        case .deletionFailed:
            return "Failed to delete the habit. Please try again."
        case .persistenceFailed:
            return "Failed to save your changes. Please try again."
        case .loadingFailed:
            return "Failed to load your data. Please restart the app."
        }
    }
}


class AppState: ObservableObject, Codable {
    
    @Published var habits: [Habit] = []
    @Published var habitsToShow: [Habit] = []
    @Published var viewingDate: Date = Date()
    @Published var currentError: AppError?
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        for habit in try values.decode([Habit].self, forKey: .habits) {
            add(habit: habit)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(habits, forKey: .habits)
    }
    
    func add(habit: Habit) {
        habits.append(habit)
        habit.objectWillChange
            .sink(receiveValue: { [weak self] in
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
        try? persist()
    }
    
    func delete(habit: Habit) {
        habits.removeAll(where: {$0.id == habit.id})
        do {
            try persist()
            objectWillChange.send()
            print("Habit deleted and persisted successfully")
        } catch {
            print("Error persisting after habit deletion: \(error)")
            habits.append(habit)
            showError(.deletionFailed)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case habits
    }
    
    func persist() throws {
        do {
            try Helpers.persistenceManager.saveData(data: self)
        } catch {
            print("Error in persist(): \(error)")
            showError(.persistenceFailed)
            throw error
        }
    }
    
    static func load() throws -> AppState {
        do {
            let loadedState = try Helpers.persistenceManager.getData()
            if loadedState.habits.isEmpty {
                print("Warning: Loaded AppState has no habits")
            }
            return loadedState
        } catch PersistenceError.noData {
            print("No existing data found, creating new AppState")
            return AppState()
        } catch {
            print("Error loading AppState: \(error)")
            let newState = AppState()
            newState.showError(.loadingFailed)
            return newState
        }
    }
    
    func toJson() -> String? {
        if let data = try? Helpers.encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func toText() -> String {
        return "RaccoonApp state \(Helpers.dateToString(Date())):\n\n\(habits.map {$0.toText()}.joined(separator: "\n"))"
    }
    
    func showError(_ error: AppError) {
        DispatchQueue.main.async {
            self.currentError = error
        }
    }
    
}

extension AppState {
    static func mockWithError(_ error: AppError? = nil) -> AppState {
        let mockState = AppState()
        mockState.currentError = error
        return mockState
    }
}
