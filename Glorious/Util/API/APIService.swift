//
//  APIService.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class APIService {
  static let base = "https://www.googleapis.com/youtube/v3"
  static let key = "AIzaSyAWr6kn5Id_50dHSUeqvMl6iF0WKvxZJeA"
  
  static let playListEndpoint = "/playlistItems"
  
  static let sermonListId = "UU4Y-jkVQdsAAqSzD51chjJQ"
  static let centerMessageListId = "UUwYStAqJNzgIEf33u7a0xiQ"
  
  enum ServiceError: Error {
    case invalidURL(String)
    case invalidParam(String, Any)
    case invalidJSON(Any)
  }
  
  static var sermons: (String) -> Observable<[Sermon]> = { listId in
    return req(endpoint: playListEndpoint, query: ["part": "snippet", "playlistId": listId, "key": key, "maxResults": 50]).map { data in
      let sermons = data["items"] as? [[String: Any]] ?? []
      return sermons.flatMap(Sermon.init)
    }.share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
  }
  
  static func req(endpoint: String, query: [String: Any] = [:]) -> Observable<[String: Any]> {
    do {
      guard let url = URL(string: base)?.appendingPathComponent(endpoint),
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        throw ServiceError.invalidURL(endpoint)
      }
      
      components.queryItems = try query.flatMap { (key, value) in
        guard let v = value as? CustomStringConvertible else {
          throw ServiceError.invalidParam(key, value)
        }
        return URLQueryItem(name: key, value: v.description)
      }
      
      guard let finalURL = components.url else { throw ServiceError.invalidURL(endpoint) }
      
      return request(.get, finalURL).flatMap { request in
        return request
          .validate(statusCode: 200..<300)
          .validate(contentType: ["application/json"])
          .rx.json().map {
            guard let result = $0 as? [String: Any] else { throw ServiceError.invalidJSON($0) }
            return result
          }
      }
    } catch { return Observable.empty() }
  }
}
