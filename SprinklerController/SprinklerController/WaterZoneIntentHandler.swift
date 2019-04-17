//
//  WaterZoneIntentHandler.swift
//  SprinklerController
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Foundation
import RachioService
import Intents

class WaterZoneIntentHandler: INExtension, WateringZoneIntentHandling {
    let service = RachioService()

    func handle(intent: WateringZoneIntent, completion: @escaping (WateringZoneIntentResponse) -> Void) {
        print("handling the watering intent")
        guard let identifier = intent.zoneID else {
            print("failed handling the watering intent")
            completion(WateringZoneIntentResponse(code: .failure, userActivity: nil))
            return
        }

        service.beginWatering(zoneID: identifier) { error in
            if let error = error {
                print("failed handling the watering intent \(error)")
                completion(WateringZoneIntentResponse(code: .failure, userActivity: nil))
                return
            }
            print("successfully handled the watering intent")
            completion(WateringZoneIntentResponse(code: .success, userActivity: nil))
        }
    }
}
