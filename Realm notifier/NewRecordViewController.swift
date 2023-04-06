//
//  NewRecordViewController.swift
//  Realm notifier
//
//  Created by Александр Щербинин on 05.04.2023.
//

import UIKit
import RealmSwift

class NewRecordViewController: UIViewController {

    @IBOutlet weak var titleLbl: UITextField!
    
    @IBOutlet weak var currentDateLbl: UITextField!
    
    @IBOutlet weak var noteLbl: UITextField!
    
    
    @IBAction func pressSaveAndReturn(_ sender: UIButton) {
        if isUpdate {
            guard titleLbl.text?.count != 0 else { return }
            delegate?.updateRecord(titleToUpdate: titleLbl.text!, noteToUpdate: noteLbl.text, sender: realmObject!)
            navigationController?.popViewController(animated: true)
        } else {
            guard readyToSave() else { return }
            delegate?.saveNewRecord(realmObject!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    var realmObject: Notes? = nil
    
    weak var delegate: NewRecordViewControllerDelegate?
    
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formFill()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func formFill() {
        
        guard let objToFill = realmObject else {
            realmObject = Notes()
            realmObject?.date = NSDate()
            currentDateLbl.text = NSDate().description
            return }
        titleLbl.text = objToFill.name
        currentDateLbl.text = objToFill.date.description
        noteLbl.text = objToFill.text
        
    }
    
    func readyToSave() -> Bool {
        if titleLbl.text?.count != 0 {
            realmObject?.name = titleLbl.text!
            realmObject?.text = noteLbl.text
            return true
        }
        return false
    }
    
}

protocol NewRecordViewControllerDelegate: AnyObject {
    func saveNewRecord(_ objectToSave: Notes)
    func updateRecord (titleToUpdate text: String, noteToUpdate note: String?, sender objectToUpdate: Notes)
}
