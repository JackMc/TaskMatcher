//
//  Activity.swift
//  TaskMatcher
//
//  Created by Jack McCracken on 2016-10-07.
//  Copyright © 2016 Jack McCracken. All rights reserved.
//

import Foundation


// Represents an approximate time of day for the activity to take place
enum TimePreference {
    case Morning
    case Afternoon
    case Evening
    
    var range : (Int, Int) {
        switch self {
        case .Morning:
            return (8,12)
        case .Afternoon:
            return (12,6)
        case .Evening:
            return (6, 10)
        }
    }
}

let weekday = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
let weekend = ["Saturday", "Sunday"]
let daysOfWeek = weekday + weekend

// Model: Represents an activity that the user wants to do

class Activity : NSObject, NSCoding {
    struct PropertyKey {
        static let name = "name"
        static let duration = "duration"
        static let preferredTime = "preferredTime"
        static let daysPreferred = "daysPreferred"
    }
    
    override var description : String {
        return "\(name) (\(duration))"
    }
    
    var name : String // Name of activity
    var duration : Int // Duration in minutes
    var preferredTime : TimePreference // The prefered time of day for this activity to occur, stored as a default
    var daysPreferred : [String] // If this event should happen on a weekday, stored as a default
    
    init(name: String, duration: Int, preferredTime: TimePreference, daysPreferred: [String]) {
        self.name = name
        self.duration = duration
        self.preferredTime = preferredTime
        self.daysPreferred = daysOfWeek
    }
    
    convenience override init() {
        self.init(name: "Blah", duration: 30, preferredTime: .Morning, daysPreferred: daysOfWeek)
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(self.duration, forKey: PropertyKey.duration)
        aCoder.encode(preferredTime, forKey: PropertyKey.preferredTime)
        aCoder.encode(daysPreferred, forKey: PropertyKey.daysPreferred)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        let duration = aDecoder.decodeObject(forKey: PropertyKey.duration) as! Int
        let preferredTime = aDecoder.decodeObject(forKey: PropertyKey.preferredTime) as! TimePreference
        let daysPreferred = aDecoder.decodeObject(forKey: PropertyKey.daysPreferred) as! [String]
        
        self.init(name: name, duration: duration, preferredTime: preferredTime, daysPreferred: daysPreferred)
    }
}
