//
//  TransactionsViewController.swift
//  Allowance Table View
//
//  Created by James Penny on 02/12/2022.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var itemArray = [Item]()
    

    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath)
        
        loadItems()
        
    }
    

    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var descriptionTextField = UITextField()
        var valueTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Transaction", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            
            
            var newItem = Item(description: "", value: 0.0)
            
        
            
            newItem.description = descriptionTextField.text!
            newItem.value = Double(valueTextField.text!)!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {(ACTION) in print("Cancel")}
        
        alert.addTextField { (alertTextFieldDescription) in
            alertTextFieldDescription.placeholder = "Description"
            descriptionTextField = alertTextFieldDescription
        }
        
        alert.addTextField { (alertTextFieldValue) in
            alertTextFieldValue.placeholder = "Value"
            valueTextField = alertTextFieldValue
        }
        
        action.isEnabled = false
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data  = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}



//MARK: - Tablewiew Datasource Methods

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        configureText(for: cell, with: item)
        
        return cell
        
    }
    
    func configureText(for cell:UITableViewCell, with item: Item){
      if let toDoItemCell = cell as? SpendItemTableViewCell {
          toDoItemCell.spendDescriptionText.text = item.description
//          toDoItemCell.spendValueText.text = item.value
          toDoItemCell.spendValueText.text = "£" + String(format: "%.2f", item.value)
      }
    }
    
    

    //MARK: - TableView Delegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
//        This currently unhighlights the row once the user lifts their finger
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        itemArray.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
        saveItems()
    }
    
    
}







