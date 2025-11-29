protocol TodofukenRepository : Sendable {
    func fetchTodofuken() async throws -> [Todofuken]
    func saveTodofuken(_ todofuken: Todofuken) async throws
    func deleteTodofuken(_ id:String ) async throws
}
