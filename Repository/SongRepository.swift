protocol SongRepository : Sendable {
    func fetchSongs() async throws -> [Song]
    
    func saveSongs(_ song : Song) async throws

    func deleteSong(_ id : String) async throws
}