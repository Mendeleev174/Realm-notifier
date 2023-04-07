//
//  NewRecordViewControllerDelegate.swift
//  Realm notifier
//
//  Created by Александр Щербинин on 07.04.2023.
//

import Foundation

//  MARK: - Протокол NewRecordViewControllerDelegate

protocol NewRecordViewControllerDelegate: AnyObject {
    func saveNewRecord(_ objectToSave: Notes)
    func updateRecord (titleToUpdate text: String, noteToUpdate note: String?, sender objectToUpdate: Notes)
}
