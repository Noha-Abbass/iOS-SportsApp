//
//  LeagueDetailsViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/22/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData
import FaveButton


class LeagueDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
   
    @IBOutlet weak var firstCollectionView: UICollectionView!
    @IBOutlet weak var secondCollectionView: UICollectionView!
    @IBOutlet weak var thirdCollectionView: UICollectionView!

    
    var leagueId : String = ""
    var leagueName : String = ""
    var LeagueBadge : String = ""
    
    var EventDict : EventResponse?
    var Events = [Event]()
    
    var TeamDict : TeamResponse?
    var Teams = [Team]()
    
    var color : UIColor?
   
    @IBAction func addToFavourites(_ sender: FaveButton) {
        
        
        print("favourite name:\(leagueName)")
        print("favourite badge: \(LeagueBadge)")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Leagues", in: manageContext)
        
        let league = Leagues(context: manageContext)
        
        Alamofire.request(self.LeagueBadge).responseImage { response in
            if let image = response.result.value {
                print("image downloaded: \(image)")
                let imageData = image.jpegData(compressionQuality: 0.75)
                league.setValue(imageData, forKey: "image")
            }
        }
        league.setValue(leagueName, forKey: "strLeague")
        league.setValue(LeagueBadge, forKey: "strBadge")
        league.setValue(leagueId, forKey: "id")
        
        
        
        do{
            try manageContext.save()
        }catch let error{
            print(error)
        }
    }

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCollectionView.dataSource = self;
        firstCollectionView.delegate = self
        
        secondCollectionView.dataSource = self
        secondCollectionView.delegate = self
        
        thirdCollectionView.dataSource = self
        thirdCollectionView.delegate = self
        
        
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id=\(self.leagueId)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(EventResponse.self, from: response.data as! Data)
                    self.EventDict = dictionary
                    self.Events = self.EventDict!.events
                    self.firstCollectionView?.reloadData()
                  
                } catch let error{
                    print(error)
                }
        }
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/eventspastleague.php?id=\(self.leagueId)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(EventResponse.self, from: response.data as! Data)
                    self.EventDict = dictionary
                    self.Events = self.EventDict!.events
                    self.secondCollectionView?.reloadData()
                    
                } catch let error{
                    print(error)
                }
        }
        
        let replaced = leagueName.replacingOccurrences(of: " ", with: "%20")
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=\(replaced)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(TeamResponse.self, from: response.data as! Data)
                    self.TeamDict = dictionary
                    self.Teams = self.TeamDict!.teams
                    self.thirdCollectionView?.reloadData()
                    print("teams are: \(self.Teams.count)")
                    
                } catch let error{
                    print(error)
                }
        }
        
        
        print("did load")
    }
    
    
  
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.firstCollectionView{
            print(self.Events.count)
            return self.Events.count
        }
        else if collectionView == self.secondCollectionView{
            return self.Events.count
        }
        else{
                return self.Teams.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.firstCollectionView{
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FirstCollectionViewCell
            print(leagueId)
            
            cellA.eventName.text = self.Events[indexPath.row].strEvent
            cellA.eventDate.text = self.Events[indexPath.row].dateEvent
            cellA.eventTime.text = self.Events[indexPath.row].strTime
            
            return cellA
        }
        else if collectionView == self.secondCollectionView{
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! SecondCollectionViewCell
     
            cellB.homeTeam.text = self.Events[indexPath.row].strHomeTeam
            cellB.awayTeam.text = self.Events[indexPath.row].strAwayTeam
            cellB.homeTeamScore.text = self.Events[indexPath.row].intHomeScore
            cellB.awayTeamScore.text = self.Events[indexPath.row].intAwayScore
            cellB.date.text = self.Events[indexPath.row].dateEvent
            cellB.time.text = self.Events[indexPath.row].strTime
            
            return cellB
        }
        
        else {
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ThirdCollectionViewCell
            print(leagueName)
            
           
            Alamofire.request(self.Teams[indexPath.row].strTeamBadge).responseImage { response in
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    
                    let roundedImage = image.af_imageRounded(withCornerRadius: 10.0)
                    let circularImage = image.af_imageRoundedIntoCircle()
                    
                    cellC.teamBadge.image = circularImage
                    //badge?.image = circularImage
                    
                    print("image loaded")
                }
            }
            
            return cellC
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if collectionView == self.thirdCollectionView{
            let TeamDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamDetailsVC") as! TeamDetailsViewController
            TeamDetailsVC.bannerUrl = Teams[indexPath.row].strTeamBanner
            TeamDetailsVC.descriptionEn = Teams[indexPath.row].strDescriptionEN
            
            self.present(TeamDetailsVC, animated: true, completion:{
                
                TeamDetailsVC.presentationController?.presentedView?.gestureRecognizers?[1].isEnabled = true
                
            })

        }
    }
    /*
    / / MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
