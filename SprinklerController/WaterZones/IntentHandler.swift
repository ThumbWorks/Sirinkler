//
//  IntentHandler.swift
//  WaterZones
//
//  Created by Roderic Campbell on 4/15/19.
//  Copyright © 2019 Thumbworks. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        print("intent thing")
        guard intent is WateringZoneIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        print("passed")
        return WaterZoneIntentHandler()
    }
    
}
