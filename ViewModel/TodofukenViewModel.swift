import SwiftUI

@MainActor
@Observable
final class TodofukenViewModel {
    private let repository : TodofukenRepository
    
    init(repository: TodofukenRepository = SupabaseTodofukenRepository()) {
         self.repository = repository
    }
    
    private var _todofuken: [Todofuken] = []
    var todofuken : [Todofuken] {
        return _todofuken
    }
    
    var path = NavigationPath()
    
    func loadTodofuken() async {
        _todofuken = try! await repository.fetchTodofuken()
    }
    
    func addTodofuken(_ todofuken: Todofuken) async {
            do {
                try await repository.saveTodofuken(todofuken)
                _todofuken.append(todofuken)
            }
            catch {
                debugPrint("에러 발생: \(error)")
            }
        }

    func deleteTodofuken(_ todofuken : Todofuken) async {
        do {
            try await repository.deleteTodofuken(todofuken.id.uuidString)
            if let index = _todofuken.firstIndex(where : { $0.id == todofuken.id }) {
                _todofuken.remove(at: index)
            }
        } catch {
            debugPrint("에러 발생: \(error)")
        }
    }
}
