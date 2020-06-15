//
//  RoomListTableTableViewController.swift
//  Anagram Ice
//
//  Created by Anthony_Kasper on 6/10/20.
//  Copyright © 2020 FirstTry. All rights reserved.
//

import UIKit

class RoomListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        queryFbForRooms {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            super.viewDidLoad()
        }
    }

    // MARK: - Table view data source

    let rowData = ["cheese", "bun", "patty"]
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = rowData[indexPath.row]
        return cell
    }
    
    func queryFbForRooms(completion : @escaping () -> ()) {
        let g = DispatchGroup()
        g.enter()
        db2.collection("Rooms").getDocuments() { (querySnapshot, err) in
            if err != nil {
                //print("Error loading room documents")
                g.leave()
            }
            else {
                for document in querySnapshot!.documents {
                    //let data = document.data()
                    //let creator  = data["creator"]
                    
                    let roomName = document.documentID // gets the name of the room
                    PublicRoomList.roomNames.append(roomName)

                    //print("Room: \(roomName) | Creator: \(creator!)")
                    g.leave()
                }
            }
        }
        g.notify(queue: .main) { completion() }
    }
    
    func readOpenRooms() {
        queryFbForRooms { () -> () in
            DispatchQueue.main.async {
                print("about to reloadData() ")
                self.tableView.reloadData()
            }
        }
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
