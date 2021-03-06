//
//  AllLeaguesTableViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 2/21/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit
import Alamofire

protocol cellDelegate {
    func didTapBtn(with title: String)
}

class AllLeaguesTableViewController: UITableViewController, cellDelegate{
    func didTapBtn(with title: String) {
        print(title)
    }
    
        
    var SoccerLeaguesList = [League]()
    var SoccerDetails = [LeagueDetail]()
    
    var LeagueDetailsDict : LeagueDetailResponse?
    var SoccerLeaguesDetails = [LeagueDetail]()
    
    var leagueId : String?
    var index : Int?
    var name : String?
    var button : UIButton?
    var delegate : cellDelegate?
   /* @IBAction func onYoutubeVideoClick(_ sender: Any) {
        
        print("button touched")
        
        let youtubeVC = self.storyboard?.instantiateViewController(withIdentifier: "youtubeVC") as! YoutubeViewController
        self.navigationController?.pushViewController(youtubeVC, animated: true)
    }*/
    
    @IBAction func onBtnClicked(_ sender: UIButton) {
        //delegate?.didTapBtn(with: name as! String)
        var superview = sender.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("button is not contained in a table view cell")
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            print("failed to get index path for cell containing button")
            return
        }
        // We've got the index path for the cell that contains the button, now do something with it.
        print("button is in row \(indexPath.row)")
        print(SoccerLeaguesList[indexPath.row].strLeague)
        print(SoccerLeaguesList[indexPath.row].idLeague)
        
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=\(self.SoccerLeaguesList[indexPath.row].idLeague)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(LeagueDetailResponse.self, from: response.data as! Data)
                    self.LeagueDetailsDict = dictionary
                    self.SoccerLeaguesDetails = self.LeagueDetailsDict!.leagues
                    let link = self.SoccerLeaguesDetails[0].strYoutube
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL.init(string: "https://\(link)")!, options: [:], completionHandler: nil)
                    }
                    
                }catch let error{
                    print(error)
                }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "stadium"))
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.backgroundColor = .clear
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return SoccerLeaguesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        

        // Configure the cell...
        var label = self.tableView.viewWithTag(1) as? UILabel
        var badge = self.tableView.viewWithTag(2) as? UIImageView
        
        
        
        label?.text = SoccerLeaguesList[indexPath.row].strLeague
        
        let parameters: Parameters = ["foo": "bar"]

    Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=\(self.SoccerLeaguesList[indexPath.row].idLeague)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
        .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
        .validate { request, response, data in return .success}
        .responseJSON { response in
        do{
            let dictionary = try JSONDecoder().decode(LeagueDetailResponse.self, from: response.data as! Data)
            self.LeagueDetailsDict = dictionary
            self.SoccerLeaguesDetails = self.LeagueDetailsDict!.leagues
            self.leagueId = self.SoccerLeaguesDetails[0].idLeague
            
            
            
            
            //badge
            Alamofire.request(self.SoccerLeaguesDetails[0].strBadge).responseImage { response in
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    
                    let roundedImage = image.af_imageRounded(withCornerRadius: 10.0)
                    let circularImage = image.af_imageRoundedIntoCircle()
                    
                    badge?.image = circularImage
                    
                    print("image loaded")
                }
                
            }
            
        } catch let error{
            print (error)
        }
    }
        
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetailsVC") as! LeagueDetailsViewController
        self.delegate = self
        
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=\(self.SoccerLeaguesList[indexPath.row].idLeague)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(LeagueDetailResponse.self, from: response.data as! Data)
                    self.LeagueDetailsDict = dictionary
                    self.SoccerLeaguesDetails = self.LeagueDetailsDict!.leagues
                    
                    
                    self.leagueId = self.SoccerLeaguesList[indexPath.row].idLeague
                    leagueDetailsVC.leagueId = self.leagueId!
                    leagueDetailsVC.leagueName = self.SoccerLeaguesList[indexPath.row].strLeague
                    leagueDetailsVC.LeagueBadge = self.SoccerLeaguesDetails[0].strBadge
                    print("details:\(leagueDetailsVC.leagueId as! String)")
                    
                    self.present(leagueDetailsVC, animated: true, completion:{
                        
                        leagueDetailsVC.presentationController?.presentedView?.gestureRecognizers?[1].isEnabled = true
                        
                    })
                    
                    
                } catch let error{
                    print(error)
                }
                
                self.name = self.SoccerLeaguesList[indexPath.row].strLeague
                print(self.name as! String)
        }
        
        
    
        
        
      /*  if self.button!.isSelected {
            print(self.SoccerLeaguesDetails[indexPath.row].strYoutube)
            UIApplication.shared.open(URL.init(string: "https://www.youtube.com/user/mls?version=3")!, options: [:], completionHandler: nil)
        }*/
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
