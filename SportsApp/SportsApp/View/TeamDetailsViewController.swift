//
//  TeamDetailsViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 3/5/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var teamBanner: UIImageView!
    
    @IBOutlet weak var desc: UITextView!
    var bannerUrl : String = ""
    var descriptionEn : String = ""
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("banner url: \(bannerUrl)")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        Alamofire.request(bannerUrl).responseImage(completionHandler: {response in
            if let image = response.result.value {
                print("image downloaded: \(image)")
                
                let scale = UIScreen.main.scale
                let aspectedScaledToFitImage = image.af_imageAspectScaled(toFill: CGSize(width: self.teamBanner.frame.width, height: 320/scale))
                
                self.teamBanner.image = aspectedScaledToFitImage
            }
        })
    
        self.desc.text = descriptionEn
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
