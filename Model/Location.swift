//
//  Location.swift
//  ToDo
//
//  Created by Tomas Sidenfaden on 7/6/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//


import Foundation
import CoreLocation

func ==(lhs: Location, rhs: Location) -> Bool {
    if lhs.coordinate?.latitude != rhs.coordinate?.latitude {
        return false
    }
    if lhs.coordinate?.longitude != rhs.coordinate?.longitude {
        return false
    }
    if lhs.name != rhs.name {
        return false
    }
    return true
}

struct Location: Equatable {

    let name: String
    let coordinate: CLLocationCoordinate2D?
    init(name: String,
         coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}
