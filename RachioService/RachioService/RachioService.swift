//
//  RachioService.swift
//  RachioService
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Foundation
import RachioModel

enum RachioError: Error {
    case noHTTPResponse
    case noData
}

public class RachioService {
    let headers: [String: String] = {

        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let token = dict["token"] else {
            return [:]
        }

        return [
            "Authorization": "Bearer \(token)",
            "Content-Type": "application/json",
            "cache-control": "no-cache",
            "Postman-Token": "43a3b8ae-f27a-4395-ab00-068515d6c5d6"
        ]
    }()
    private let imageCache = ImageCache()

    public init() {}

    public func image(for zone: Zone, onComplete: @escaping (UIImage?, Error?) -> ()) {
        imageCache.image(at: zone.imageURLString) { image, error in
            DispatchQueue.main.async {
                onComplete(image, error)
            }
        }
    }

    public func beginWatering(zoneID: String, onCompletion: @escaping (Error?) -> ()) {
        let parameters = [
            "id": zoneID,
            "duration": 60
            ] as [String : Any]

        
        let postData: Data
        do {
            postData = try JSONSerialization.data(withJSONObject: parameters, options: []) as Data
        } catch {
            onCompletion(error)
            return
        }
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rach.io/1/public/zone/start")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                onCompletion(error)
            } else {
                guard let _ = response as? HTTPURLResponse else {
                    onCompletion(RachioError.noHTTPResponse)
                    return
                }
                onCompletion(nil)
            }
        })

        dataTask.resume()
    }

    public func fetchZones(onCompletion: @escaping ([Zone]?, Error?) -> ()) {

        fetchUserID { (userID, error) in
            if let error = error {
                onCompletion(nil, error)
            } else if let userID = userID {
                self.fetchPerson(userID: userID) { (person, error) in
                    if let error = error {
                        onCompletion(nil, error)
                    } else if let person = person {
                        let zones = person.devices.first?.zones
                        onCompletion(zones, error)
                    }
                }
            } else {
                onCompletion(nil, nil)
            }
        }
    }

    private func fetchUserID(onCompletion: @escaping (String?, Error?) -> ()) {

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rach.io/1/public/person/info")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                onCompletion(nil, error)
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? Dictionary<String, String>
                    let id = json?["id"]
                    onCompletion(id, nil)
                } catch {
                    onCompletion(nil, error)
                }
            } else {
                onCompletion(nil, nil)
            }
        })

        dataTask.resume()
    }

    private func fetchPerson(userID: String, onCompletion: @escaping (Person?, Error?) -> ()) {
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rach.io/1/public/person/\(userID)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                onCompletion(nil, error)
            } else {
                guard let _ = response as? HTTPURLResponse else {
                    onCompletion(nil, RachioError.noHTTPResponse)
                    return
                }

                guard let data = data else {
                    onCompletion(nil, RachioError.noData)
                    return
                }
                do {
                    let myStruct = try JSONDecoder().decode(Person.self, from: data)
                    onCompletion(myStruct, nil)
                } catch {
                    onCompletion(nil, error)
                }
            }
        })

        dataTask.resume()
    }
}
