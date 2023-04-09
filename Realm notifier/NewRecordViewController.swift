//
//  NewRecordViewController.swift
//  Realm notifier
//
//  Created by Александр Щербинин on 05.04.2023.
//

import UIKit
import RealmSwift

class NewRecordViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleLbl: UITextField!
    
    @IBOutlet weak var currentDateLbl: UITextField!
    
    @IBOutlet weak var noteLbl: UITextView!
    
    @IBOutlet weak var characterCounter: UILabel!
    
    @IBOutlet weak var saveOrUpdateLbl: UIBarButtonItem!
    
    // Нажатие на кнопку "Save" / "Update"
    @IBAction func pressSaveOrUpdate(_ sender: UIBarButtonItem) {
        if isUpdate {
            guard titleLbl.text?.count != 0 else {
                zeroTitleAlert(sender)
                return
            }
            delegate?.updateRecord(titleToUpdate: titleLbl.text!, noteToUpdate: noteLbl.text, sender: realmObject!)
            navigationController?.popViewController(animated: true)
        } else {
            guard readyToSave() else {
                zeroTitleAlert(sender)
                return
            }
            delegate?.saveNewRecord(realmObject!)
            navigationController?.popViewController(animated: true)
        }
    }
    
    // Переменная для хранения экземпляра объекта
    var realmObject: Notes? = nil
    
    // Делегат
    weak var delegate: NewRecordViewControllerDelegate?
    
    // Работаем с обновлением объекта или нет
    var isUpdate = false
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Заполняем форму данными
        formFill()
        
        // Делегат для текстового поля
        noteLbl.delegate = self
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // Заполняем форму данными
    func formFill() {
        
        guard let objToFill = realmObject else {
            realmObject = Notes()
    
            // Вставка текущей даты и времени для НОВОЙ записи
            realmObject?.date = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy, hh:mm"
            dateFormatter.timeZone = .current
            currentDateLbl.text = dateFormatter.string(from: realmObject!.date as Date)
            
            textViewDidChangeSelection(noteLbl)
            return }
        titleLbl.text = objToFill.name
        
        // Вставка текущей даты и времени из СУЩЕСТВУЮЩЕЙ записи
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, hh:mm"
        dateFormatter.timeZone = .current
        currentDateLbl.text = dateFormatter.string(from: objToFill.date as Date)
        
        noteLbl.text = objToFill.text
        navigationItem.title = "Update record"
        saveOrUpdateLbl.title = "Update"
        textViewDidChangeSelection(noteLbl)
    }
    
    // Готовы ли сохранить новый объект
    func readyToSave() -> Bool {
        if titleLbl.text?.count != 0 {
            realmObject?.name = titleLbl.text!
            realmObject?.text = noteLbl.text
            return true
        }
        return false
    }

    // Alert о невозможности сохранения записи по причине отсутствия заголовка
    func zeroTitleAlert(_ sender: UIBarButtonItem) {
        let buttonTitle = sender.title!
        let alert = UIAlertController(title: "\(buttonTitle) alert", message: "Record should contain title", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Методы UITextViewDelegate

    func textViewDidChangeSelection(_ textView: UITextView) {
        characterCounter.text = textView.text?.count.description
        characterCounter.text! += " characters"
    }
    
}

