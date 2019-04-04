//
//  CompteurViewController.swift
//  Compteur
//
//  Created by Lucas Stoebner on 10/03/2019.
//  Copyright © 2019 LucasStbnr. All rights reserved.
//

import UIKit
import os.log

class CompteurViewController: UIViewController, UITextFieldDelegate {
	
	//MARK: Properties
	
	@IBOutlet weak var lblCounter: UILabel!
	@IBOutlet weak var topBackground: UIView!
	@IBOutlet weak var boutonPlus: UIButton!
	@IBOutlet weak var boutonMoins: UIButton!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	
	/*
	This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
	or constructed as part of adding a new meal.
	*/
	var compteur: Compteur?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set up views if editing an existing Meal.
		if let compteur = compteur {
			navigationItem.title = compteur.name
			lblCounter.text = "\(compteur.value)"
			counter = compteur.value
		}
		
	}
	
	//MARK: Navigation
	@IBAction func cancel(_ sender: Any) {
		// Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
		let isPresentingInAddCompteurMode = presentingViewController is UINavigationController
		
		if isPresentingInAddCompteurMode {
			dismiss(animated: true, completion: nil)
		}
		else if let owningNavigationController = navigationController{
			owningNavigationController.popViewController(animated: true)
		}
		else {
			fatalError("The MealViewController is not inside a navigation controller.")
		}
	}
	
	// This method lets you configure a view controller before it's presented.
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		
		// Configure the destination view controller only when the save button is pressed.
		guard let button = sender as? UIBarButtonItem, button === saveButton else {
			os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
			return
		}
		
		compteur = Compteur(name: (compteur?.name) ?? "Compteur", value: counter)
	}
	
	//MARK: Actions
	
	@IBAction func btnCounter1Plus(_ sender: Any) {
		if (counter < 999){
			counter += 1
			lblCounter.text = "\(counter)"
		}
	}
	
	@IBAction func btnCounter1Moins(_ sender: Any) {
		if (counter > 0){
			counter -= 1
			lblCounter.text = "\(counter)"
		}
	}
	
	@IBAction func btnPlusHold(_ sender: Any) {
		if (counter < 999){
			counter += 1
			lblCounter.text = "\(counter)"
		}
	}
	
	@IBAction func btnMinusHold(_ sender: Any) {
		if (counter > 0){
			counter -= 1
			lblCounter.text = "\(counter)"
		}
	}
	
	//MARK: UITextFieldDelegate
	
	@IBAction func nameCounterExit(_ sender: Any) {
		resignFirstResponder()
		lblCounter.text = "\(counter)"
	}
	
	//MARK: Variables
	
	var counter = 0
	
	//MARK: Private functions
	
}
