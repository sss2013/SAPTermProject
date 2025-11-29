import SwiftUI

@MainActor
@Observable
final class SongViewModel {
    private let repository: SongRepository

    init (repository: SongRepository = SupabaseSongRepository()) {
        self.repository = repository
    }

    private var _songs: [Song] =[]
    var songs: [Song] { _songs}

    var path = NavigationPath()

    func loadSongs() async{
        do {
            _songs = try await repository.fetchSongs()
        } catch {
            print("에러 발생: \(error)")
        } 
    }

    func addSong(_ song :  Song) async{ 
        do {
            try await repository.saveSongs(song)
            _songs.append(song)
        } catch {
            print("에러 발생: \(error)")
        }
    }

    func deleteSong(_ song : Song) async {
        do {
            try await repository.deleteSong(song.id.uuidString)
            if let index = _songs.firstIndex(where : { $0.id == song.id }) {
                _songs.remove(at: index)
            }
        } catch {
            debugPrint("에러 발생: \(error)")
        }
    }
}