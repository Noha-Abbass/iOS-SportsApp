//
//  Sport.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/18/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import Foundation

struct SportResponse : Codable{
    var sports : [Sport]
}

struct Sport : Codable{
    var idSport : String
    var strSport : String
    var strFormat : String
    var strSportThumb : String
    var strSportThumbGreen : String
    var strSportDescription : String
}
