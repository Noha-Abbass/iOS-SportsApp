//
//  LeagueDetail.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/21/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import Foundation

struct LeagueDetailResponse : Codable{
    var leagues : [LeagueDetail]
}

struct LeagueDetail : Codable{
    var idLeague : String
    var strLeague : String
    var strSport : String
    var strYoutube : String
    var strBadge : String
}
