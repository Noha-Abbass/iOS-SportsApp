//
//  FavouritesTableViewController.swift
//  SportsApp
//
//  Created by MacOSSierra on 3/5/21.
//  Copyright © 2021 asmaa. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import Network


class FavouritesTableViewController: UITableViewController{
    
    var leagues = [Leagues]()
    
    var SoccerLeaguesList = [League]()
    var SoccerDetails = [LeagueDetail]()
    
    var LeagueDetailsDict : LeagueDetailResponse?
    var SoccerLeaguesDetails = [LeagueDetail]()
    

    
    func monitorNetwork(){
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {path in
            if path.status == .satisfied{
                print("connected!!!!!!!!!!!!")
            }else {
                print("not connected!!!!!")
                let alert = UIAlertController(title: "no internet", message: "needs internet", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    
        let queue = DispatchQueue(label: "network")
        monitor.start(queue: queue)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Leagues")
        
        do{
            leagues = try manageContext.fetch(fetchRequest) as! [Leagues]
        }catch let error{
            print(error)
        }
        self.tableView.reloadData()

    }

    override func viewWillAppear(_ animated: Bool) {
        //monitorNetwork()
        viewDidLoad()
        self.tableView.reloadData()
        
        print("total core: \(leagues.count)")
        //print(leagues[0].strLeague as! String)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return leagues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var label = self.tableView.viewWithTag(1) as? UILabel
        var badge = self.tableView.viewWithTag(2) as? UIImageView
        
        label?.text = leagues[indexPath.row].strLeague
        if let data = leagues[indexPath.row].image{
            badge?.image = UIImage(data: data)
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let leagueDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "leagueDetailsVC") as! LeagueDetailsViewController
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = {path in
            if path.status == .satisfied{
                print("connected!!!!!!!!!!!!")
            print(self.leagues[0].id!)
        
        let parameters: Parameters = ["foo": "bar"]
        
        Alamofire.request("https://www.thesportsdb.com/api/v1/json/1/lookupleague.php?id=\(self.leagues[indexPath.row].id!)", method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in }
            .validate { request, response, data in return .success}
            .responseJSON { response in
                do{
                    let dictionary = try JSONDecoder().decode(LeagueDetailResponse.self, from: response.data as! Data)
                    self.LeagueDetailsDict = dictionary
                    self.SoccerLeaguesDetails = self.LeagueDetailsDict!.leagues
                    leagueDetailsVC.leagueId = self.leagues[indexPath.row].id!
                    leagueDetailsVC.leagueName = self.leagues[indexPath.row].strLeague!
                    
                    self.present(leagueDetailsVC, animated: true, completion:{
                        
                        leagueDetailsVC.presentationController?.presentedView?.gestureRecognizers?[1].isEnabled = true
                        
                    })
                    
                } catch let error{
                    print(error)
                }
        }
            }
            else {
                print("not connected!!!!!")
                let alert = UIAlertController(title: "No Internet Connection", message: "Please check your  connection and try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: "default action"), style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
            
        }
        let queue = DispatchQueue(label: "network")
        monitor.start(queue: queue)
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
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
