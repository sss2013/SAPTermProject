import Foundation

final class SupabaseTodofukenRepository : TodofukenRepository {
    func fetchTodofuken() async throws -> [Todofuken] {
           let requestURL = URL(string: TodofukenApiConfig.serverURL)!
           let (data, _) = try await URLSession.shared.data(from: requestURL)
           let decoder = JSONDecoder()
           return try! decoder.decode([Todofuken].self, from: data)
       }
    
    func saveTodofuken(_ todofuken: Todofuken) async throws {
            let requestURL = URL(string: TodofukenApiConfig.serverURL)!
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(todofuken)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            //debugPrint(response)

            // Guard cluase (조건에 맞지 않으면 바로 return (여기서는 throw)) 사용
            guard let httpResponse = response
                    as? HTTPURLResponse,
                    httpResponse.statusCode == 201
            else {
                throw URLError(.badServerResponse)
            }
        }
        
    func deleteTodofuken(_ id : String) async throws {
        let urlString = "\(TodofukenApiConfig.serverURL)/rest/v1/todofuken?id=eq.\(id)&apikey=\(TodofukenApiConfig.apiKey)"

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
