//
//  CompteurTableViewController.swift
//  Compteur
//
//  Created by Lucas Stoebner on 14/03/2019.
//  Copyright © 2019 LucasStbnr. All rights reserved.
//

import UIKit
import os.log

class CompteurTableViewController: UITableViewController {

	//MARK: Properties
	
	var compteurs = [Compteur]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Use the edit button item provided by the table view controller.
		navigationItem.leftBarButtonItem = editButtonItem
		navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 56/255, green: 62/255, blue: 78/255, alpha: 1)
		
		// Load the sample data.
		if let savedCompteurs = loadCompteurs(){
			compteurs += savedCompteurs
		}
		else{
			loadSampleCompteurs()
		}
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compteurs.count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// Table view cells are reused and should be dequeued using a cell identifier.
		let cellIdentifier = "CompteurTableViewCell"
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CompteurTableViewCell  else {
			fatalError("The dequeued cell is not an instance of CompteurTableViewCell.")
		}
		
		// Fetches the appropriate compteur for the data source layout.
		let compteur = compteurs[indexPath.row]
		
		cell.nameLabel.text = compteur.name
		cell.valueLabel.text = "\(compteur.value)"
		
		return cell
	}

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

	
    // Override to support editing the table view.
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			// Delete the row from the data source
			compteurs.remove(at: indexPath.row)
			saveCompteurs()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}
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

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		switch(segue.identifier ?? "") {
			
		case "AddItem":
			os_log("Adding a new compteur.", log: OSLog.default, type: .debug)
			
		case "ShowDetail":
			guard let compteurDetailViewController = segue.destination as? CompteurViewController else {
				fatalError("Unexpected destination: \(segue.destination)")
			}
			
			guard let selectedCompteurCell = sender as? CompteurTableViewCell else {
				fatalError("Unexpected sender: \(String(describing: sender))")
			}
			
			guard let indexPath = tableView.indexPath(for: selectedCompteurCell) else {
				fatalError("The selected cell is not being displayed by the table")
			}
			
			let selectedCompteur = compteurs[indexPath.row]
			compteurDetailViewController.compteur = selectedCompteur
			
		default:
			fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
		}
    }
	
	//MARK: Actions
	
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(at: indexPath)
		let edit = editAction(at: indexPath)
		return UISwipeActionsConfiguration(actions: [delete, edit])
	}
	
	func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
		let action = UIContextualAction(style: .destructive, title: "supprimer") { (action, view, completion) in
			self.compteurs.remove(at: indexPath.row)
			self.tableView.deleteRows(at: [indexPath], with: .automatic)
			completion(true)
			self.saveCompteurs()
		}
		
		action.image = UIImage(named: "Corbeille")
		return action
	}
	
	func editAction(at indexPath: IndexPath) -> UIContextualAction{
		let compteur = compteurs[indexPath.row]
		let action = UIContextualAction(style: .normal, title: "modifier") { (action, view, completion) in
			let alertController = UIAlertController(title: "Modifier le nom", message: "", preferredStyle: .alert)
			
			let confirmAction = UIAlertAction(title: "Entrer", style: .default) { (_) in
				
				//getting the input value from user
				let name = alertController.textFields?[0].text
				compteur.name = name ?? "Compteur"
				self.tableView.reloadRows(at: [indexPath], with: .none)
				self.saveCompteurs()
			}
			
			let cancelAction = UIAlertAction(title: "Annuler", style: .cancel) { (_) in }
			
			//adding textfields to our dialog box
			alertController.addTextField { (textField) in
				textField.placeholder = "Compteur"
			}
			
			//adding the action to dialogbox
			alertController.addAction(confirmAction)
			alertController.addAction(cancelAction)
			
			self.present(alertController, animated: true, completion: nil)
			completion(true)
		}
		action.image = UIImage(named: "Edit")
		return action
	}
	
	@IBAction func unwindToCompteurList(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? CompteurViewController, let compteur = sourceViewController.compteur {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				// Update an existing meal.
				compteurs[selectedIndexPath.row] = compteur
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			}
			else {
				// Add a new compteur.
				let newIndexPath = IndexPath(row: compteurs.count, section: 0)
				
				compteurs.append(compteur)
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
			saveCompteurs()
		}
	}
	
	//MARK: Private Methods
	
	private func loadSampleCompteurs() {
		
		guard let compteur1 = Compteur(name: "Compteur", value: 0) else {
			fatalError("Unable to instantiate compteur1")
		}
		
		compteurs += [compteur1]
	}
	
	func saveCompteurs(){
		do{
			let dataCompteurs = try NSKeyedArchiver.archivedData(withRootObject: compteurs, requiringSecureCoding: false)
			try dataCompteurs.write(to: Compteur.archiveURL)
		}catch{
			os_log("Error when saving compteurs", log: OSLog.default, type: .error)
		}
	}
	
	func loadCompteurs() -> [Compteur]? {
		do{
			return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: Compteur.archiveURL)) as?[Compteur]
		}catch{
			os_log("ERROR cant't load compteurs", log: OSLog.default, type: .error)
			return nil
		}
	}
}
