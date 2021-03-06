//
//  League.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/21/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import Foundation

struct LeagueResponse : Codable{
    var leagues : [League]
}

struct League : Codable{
    var idLeague : String
    var strLeague : String
    var strSport :String
    
}
