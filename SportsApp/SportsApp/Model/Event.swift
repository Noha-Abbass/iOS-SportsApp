//
//  Event.swift
//  SportsApp
//
//  Created by MacOSSierra on 3/4/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import Foundation

struct EventResponse : Codable{
    var events : [Event]
}

struct Event : Codable{
    var strEvent : String
    var dateEvent : String
    var strTime : String
    var strHomeTeam : String
    var strAwayTeam : String
    var intHomeScore : String
    var intAwayScore : String
    
}
