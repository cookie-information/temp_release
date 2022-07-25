import Foundation

struct AuthRequest: Encodable {
    let clientId: String
    let clientSecret: String
    let grantType: String = "client_credentials"
}

struct AuthResponse: Decodable {
    let accessToken: String?
    private let expiresIn: Int?
    var expiresAt: Date { expiresIn != nil ? Date(timeIntervalSinceNow: Double(expiresIn!)) : Date() }
    
    var errorDescription: String?
    var error: String?
}
