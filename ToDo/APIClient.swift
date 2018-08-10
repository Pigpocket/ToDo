//
//  APIClient.swift
//  ToDo
//
//  Created by Tomas Sidenfaden on 8/4/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//
import UIKit

class APIClient {
    
    lazy var session: SessionProtocol = URLSession.shared
    
    func loginUser(withName username: String,
                   password: String,
                   completion: @escaping (Token , Error ) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "awesometodos.com"
        components.path = "/login"
        let queryUsername = URLQueryItem(name: "username", value: username)
        let queryPassword = URLQueryItem(name: "password", value: password)
        components.queryItems = [queryUsername, queryPassword]
        guard let url = components.url else {
                fatalError()
        }
        session.dataTask(with: url) { (data, response, error) in
        }
    }
    
}

protocol SessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping
        (Data?, URLResponse?, Error?) -> Void)
        -> URLSessionDataTask
}

extension URLSession: SessionProtocol {}


