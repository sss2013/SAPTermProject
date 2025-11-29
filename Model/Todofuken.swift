import Foundation

enum Region: String, CaseIterable, Hashable, Codable {
    case Hokkaido, Tohoku, Kanto, Chubu, Kinki, Shikoku, Chugoku, Kyushu_okinawa
    case unknown

    init (from decoder : Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = Region(rawValue: rawValue ?? "") ?? .unknown
    }

    var displayName: String {
        switch self {
        case .Hokkaido: return "홋카이도"
        case .Tohoku: return "도호쿠"
        case .Kanto: return "간토"
        case .Chubu: return "주부"
        case .Kinki: return "긴키"
        case .Shikoku: return "시코쿠"
        case .Chugoku: return "주고쿠"
        case .Kyushu_okinawa: return "큐슈·오키나와"
        case .unknown: return "알 수 없음"
        }
    }

}

struct Todofuken: Identifiable, Decodable, Encodable, Hashable{
    let id: UUID
    let name_ja: String
    let name_ko: String
    let description: String 
    let region: Region
    let url : String?
    let rating : Int
}
