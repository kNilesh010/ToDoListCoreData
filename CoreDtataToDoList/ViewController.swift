//
//  ViewController.swift
//  CoreDtataToDoList
//
//  Created by Nilesh Kumar on 31/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    private var modelItems = [ToDoList]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let table: UITableView = {
        let table = UITableView()
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        title = "Core Data ToDo List"
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.frame = view.bounds
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapButton))
    }
    
    @objc func didTapButton(){
        let alert = UIAlertController(title: "New Item", message: "Add New item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
            self?.createItems(name: text)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        
        present(alert, animated: true)
    }
    
    //Core Data

    func getAllItems(){
        do{
            modelItems = try context.fetch(ToDoList.fetchRequest())
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }catch {
            print(error)
        }
    }
    
    func createItems(name: String){
       let newItem = ToDoList(context: context)
        newItem.itemName = name
        newItem.createdDate = Date()
        
        do{
            try context.save()
            getAllItems()
            
        }catch{
            
        }
    }
    
    func updateItems(items: ToDoList, newName: String){
        items.itemName = newName
        getAllItems()

    }
    
    func deleteItems(items: ToDoList){
        
        context.delete(items)
        
        do{
            try context.save()
            getAllItems()
        }catch{
            
        }

    }

}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.itemName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let items = modelItems[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sheet = UIAlertController(title: "Edit", message: "Edit an item", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: {_ in
            
            let alert = UIAlertController(title: "Edit Item", message: "Edit an item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = items.itemName
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
                self?.updateItems(items: items, newName: text)
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
            
            self.present(alert, animated: true)
            
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] _ in
            
            self?.deleteItems(items: items)
            
        }))
        
        present(sheet, animated: true)
    }
}
