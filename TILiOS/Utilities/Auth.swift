//
//  Auth.swift
//  TILiOS
//
//  Created by Rychillie Umpierre de Oliveira on 09/05/25.
//

import Foundation

enum AuthResult {
    case success
    case failure
}

class Auth: ObservableObject {
    static let keychainKey = "TIL-API-KEY"
    
    @Published var isAuthenticated: Bool = false
    
    var token: String? {
        get {
            Keychain.load(key: Auth.keychainKey)
        }
        set {
            if let newToken = newValue {
                Keychain.save(key: Auth.keychainKey, data: newToken)
                // ADD: Update isAuthenticated when token is set
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
            } else {
                Keychain.delete(key: Auth.keychainKey)
                // ADD: Update isAuthenticated when token is removed
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    init() {
        // Check if a token already exists at app launch
        if Keychain.load(key: Auth.keychainKey) != nil {
            self.isAuthenticated = true
        }
    }
    
    func logout() {
        token = nil
    }
    
    func login(username: String, password: String, completion: @escaping (AuthResult) -> Void) {
        let path = "http://localhost:8080/api/users/login"
        guard let url = URL(string: path) else {
            // It's generally better to handle this error gracefully than to fatalError in production code
            // For now, we'll keep fatalError as it was, but consider changing it.
            fatalError("Failed to convert URL")
        }
        guard
            let loginString = "\(username):\(password)"
                .data(using: .utf8)?
                .base64EncodedString()
        else {
            fatalError("Failed to encode credentials")
        }
        
        var loginRequest = URLRequest(url: url)
        loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
        loginRequest.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: loginRequest) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                // ADD: Ensure isAuthenticated is false on failure and completion is called on main thread
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    completion(.failure)
                }
                return
            }
            
            do {
                let token = try JSONDecoder().decode(Token.self, from: jsonData)
                // The 'token' property setter will handle 'isAuthenticated'
                self.token = token.value
                // ADD: Call completion on main thread
                DispatchQueue.main.async {
                    completion(.success)
                }
            } catch {
                // ADD: Ensure isAuthenticated is false on failure and completion is called on main thread
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    completion(.failure)
                }
            }
        }
        dataTask.resume()
    }
}
