//
//  APIService.swift
//  Glorious
//
//  Created by hPark_ipl on 2017. 11. 13..
//  Copyright © 2017년 church. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class APIService {
  static let base = "https://www.googleapis.com/youtube/v3"
  static let key = "AIzaSyAWr6kn5Id_50dHSUeqvMl6iF0WKvxZJeA"
  
  static let playListEndpoint = "/playlistItems"
  static let videosEndpoint = "/videos"
  
  static let sermonListId = "UU4Y-jkVQdsAAqSzD51chjJQ"
  static let centerMessageListId = "UUwYStAqJNzgIEf33u7a0xiQ"
  
  // 62가지
  static let messageId62 = "XOWZHSgo2cE"
  // 강단
  static let messageIdMain = "eqpjAUrxAIw"
  // 1분
  static let messageId1Min = "tLVsSZCuanI"
  // 3분
  static let messageId3Min = "ADI7UI87BK8"
  // 5분
  static let messageId5Min = "EjVYo15-3QU"
  
  enum ServiceError: Error {
    case invalidURL(String)
    case invalidParam(String, Any)
    case invalidJSON(Any)
  }
  
  static var sermon: (String) -> Observable<Sermon> = { videoId in
    return req(endpoint: videosEndpoint, query: ["part": "snippet", "id": videoId, "key": key]).map { data in
      let sermon = data["items"] as? [[String: Any]] ?? []
      guard let first = sermon.flatMap(Sermon.init).first else { return Sermon() }
      return first
    }.share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
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
  
  static func checkAvailability(check: @escaping (Bool) -> (Void)) {
    
    let manager = Alamofire.SessionManager.default
    manager.session.configuration.timeoutIntervalForRequest = 8
    
    manager.request("\(base)\(videosEndpoint)", method: .get, parameters: ["part": "snippet", "id": messageIdMain, "key": key]).responseJSON { response in
        switch (response.result) {
        case .success: check(true)
        case .failure(let error): check(false)
          print("\n\nAuth request failed with error:\n \(error)")
        }
    }
  }
}
