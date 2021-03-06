//
//  YoutubeViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/22/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubeViewController: UIViewController {

   
    @IBOutlet weak var playerView: YTPlayerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.load(withVideoId: "UCG5qGWdu8nIRZqJ_GgDwQ-w")
        /*playerView.loadVideo(byURL: "https://www.youtube.com/user/mls?version=3", startSeconds: 0.0)
        playerView.playVideo()*/
        UIApplication.shared.open(URL.init(string: "https://www.youtube.com/user/mls?version=3")!, options: [:], completionHandler: nil)
        
    }

}
