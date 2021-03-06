//
//  CustomCollectionViewCell.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/18/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sportImage: UIImageView!
    @IBOutlet weak var sportName: UILabel!
    
    
    func setup(with sport : Sport){
        sportName?.text = sport.strSport
    }
}
