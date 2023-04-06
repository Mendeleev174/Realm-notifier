//
//  TableViewController.swift
//  Realm notifier
//
//  Created by Александр Щербинин on 05.04.2023.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {

    @IBAction func PressAdd(_ sender: UIBarButtonItem) {
        let addVC = storyboard?.instantiateViewController(withIdentifier: "NewVC")
        let addVC2 = addVC as! NewRecordViewController
        addVC2.delegate = self
        navigationController?.pushViewController(addVC2, animated: true)
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return realm.objects(Notes.self).count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)

        let realmObjects = realm.objects(Notes.self)
        cell.textLabel?.text = realmObjects[indexPath.row].name
        cell.detailTextLabel?.text = realmObjects[indexPath.row].date.description

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let toDoDelete = realm.objects(Notes.self)
            try! realm.write {
                realm.delete(toDoDelete[indexPath.row])
            }
            // следующую строку важно ставить в конце условия, так как после удаления строки в таблице, она обновляется с новым количеством строк из базы данных
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addVC = storyboard?.instantiateViewController(withIdentifier: "NewVC")
        let addVC2 = addVC as! NewRecordViewController
        let objectToSend = realm.objects(Notes.self)
        addVC2.realmObject = objectToSend[indexPath.row]
        addVC2.isUpdate = true
        addVC2.delegate = self
        navigationController?.pushViewController(addVC2, animated: true)
    }
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

extension TableViewController: NewRecordViewControllerDelegate {
    
    func saveNewRecord(_ objectToSave: Notes) {
        try! realm.write {
            realm.add(objectToSave)
        }
        tableView.reloadData()
    }
    
    func updateRecord(titleToUpdate text: String, noteToUpdate note: String?, sender objectToUpdate: Notes) {
        try! realm.write {
            objectToUpdate.name = text
            objectToUpdate.text = note
        }
        tableView.reloadData()
    }
    
}
