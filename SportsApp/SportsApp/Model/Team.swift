//
//  Team.swift
//  SportsApp
//
//  Created by MacOSSierra on 3/4/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import Foundation

struct TeamResponse : Codable{
    var teams : [Team]
}

struct Team : Codable{
    var strTeamBadge : String
    var strTeam : String
    var strTeamBanner : String
    var strDescriptionEN : String
}
