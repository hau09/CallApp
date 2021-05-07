//
//  KeyCenter.swift
//  CallApp
//
//  Created by hau on 5/6/21.
//

import Foundation

struct KeyCenter {
    static let AppID = "0670ebbbe9234a4c95931be132490dc1"
    
    
    static func getToken(channelID: String) -> String? {
        guard let tokenServerURL = URL(
            string: "https://call-app-final.glitch.me/access_token?channelName=\(channelID)") else {return nil}
        //semaphore is used to wait for the request to complete, before returning the token.
        let semaphore = DispatchSemaphore(value: 0)
        var request = URLRequest(url: tokenServerURL, timeoutInterval: 10)
        request.httpMethod = "GET"
        var tokenToReturn = ""
        let task = URLSession.shared.dataTask(
            with: request
        ) { data, response, err in
            defer {
                       // Signal that the request has completed
                       semaphore.signal()
                   }
            guard let data = data else {
                // No data, no token
                return
            }
            // parse response into json
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
           
            if let token = responseJSON?["token"] as? String {
                tokenToReturn = token
            }
        }
        task.resume()
        semaphore.wait()
        return tokenToReturn
    }
}
