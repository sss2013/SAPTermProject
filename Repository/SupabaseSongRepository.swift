import Foundation

final class SupabaseSongRepository : SongRepository {
    func fetchSongs() async throws -> [Song] {
        let requestURL = URL (string : SongApiConfig.serverURL)!
        let (data, _) = try await URLSession.shared.data(from: requestURL)
        let decoder = JSONDecoder()
        return try! decoder.decode([Song].self, from: data)
    }

    func saveSongs(_ song : Song) async throws {
        let requestURL = URL (string : SongApiConfig.serverURL)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(song)
        
        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 201
        else {
            throw URLError(.badServerResponse)
        }
    }

    func deleteSong(_ id : String) async throws {
        let urlString = "\(SongApiConfig.serverURL)/rest/v1/songs?id=eq.\(id)&apikey=\(SongApiConfig.apiKey)"

        let requestURL = URL (string : urlString)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 204
        else {
            throw URLError(.badServerResponse)
        }
    }
}