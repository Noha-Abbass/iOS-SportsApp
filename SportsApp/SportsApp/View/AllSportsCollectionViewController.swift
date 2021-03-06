//
//  AllSportsCollectionViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/16/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

private let reuseIdentifier = "Cell"



class AllSportsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    var Sportdict : SportResponse?
    var allSports = [Sport]()
    
    var LeagueDict : LeagueResponse?
    var allLeagues = [League]()
    var Soccerleagues = [League]()
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("did load")
        self.activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        // Register cell classes
       // self.collectionView!.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        // Get all sports
        
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_sports.php", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                    do{
                        let dictionary = try JSONDecoder().decode(SportResponse.self, from: response.data as! Data)
                        self.Sportdict = dictionary
                        self.allSports = self.Sportdict!.sports
                        
                        //print(self.allSports.count)
                        
                        self.collectionView?.reloadData()
                    } catch let error{
                        print (error)
                    }
                }
        }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return allSports.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if let sportCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CustomCollectionViewCell{
            if allSports.count != 0 {
                sportCell.setup(with: allSports[indexPath.row])
                
                
                Alamofire.request(allSports[indexPath.row].strSportThumb).responseImage { response in
                    if let image = response.result.value {
                        print("image downloaded: \(image)")
                        let size = CGSize(width: 300.0, height: 200.0)
                        let scale = UIScreen.main.scale
                        let aspectedScaledToFitImage = image.af_imageAspectScaled(toFill: CGSize(width: sportCell.frame.width, height: 320/scale))
                        
                        sportCell.sportImage.image = aspectedScaledToFitImage
                    }
                }
            }
            cell = sportCell
        }
        
        return cell
    }
    
    
    
    //MARK: Remove Spacing
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.size.width
        let scaleFactor = (screenWidth / 2) - 0
        
        return CGSize(width: scaleFactor, height: scaleFactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: SelectItem
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected at \(indexPath)")
        if indexPath.row == 0{
            let allLeaguesTVC = self.storyboard?.instantiateViewController(withIdentifier: "AllLeaguesTVC") as! AllLeaguesTableViewController
            allLeaguesTVC.SoccerLeaguesList = Soccerleagues
            //allLeaguesTVC.SoccerDetails = SoccerLeaguesDetails
            
            self.navigationController?.pushViewController(allLeaguesTVC, animated: true)
        }
       
        else{
            let alert = UIAlertController(title: "Nothing to show", message: "Please click on 'Soccer'! ", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "default action"), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/all_leagues.php", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(LeagueResponse.self, from: response.data as! Data)
                    self.LeagueDict = dictionary
                    self.allLeagues = self.LeagueDict!.leagues
                    
                    print("first league:\(self.allLeagues[0].strSport)")
                    
                    //print(self.allSports.count)
                    
                    print("leagues:")
                    self.Soccerleagues = self.getSoccerLeagues(leagues: self.allLeagues)
                } catch let error{
                    print (error)
                }
                
        }
        
    }
    
    func getSoccerLeagues(leagues : [League]) -> [League] {
        var soccer = [League]()
        soccer = leagues.filter{ $0.strSport.contains("Soccer") }
        
        //soccer.forEach{print($0)}
        return soccer
    }


    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
