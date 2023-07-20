//
//  FavoritePokemonViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 17/07/23.
//

import UIKit
import CoreData

var isChange: Bool = false
class FavoritePokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    var pokemonModel: [PokemonModel] = []
    var viewModel: ViewModel?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var detailController: DetailPokeViewController?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieve()
        print("Data = ", pokemonModel.count)
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        retrieve()
        tableView.reloadData()
    }

    private func handleUpdate(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Pokemon Name", message: nil, preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "New Name"
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
                    guard let newName = alertController.textFields?.first?.text else {
                        return
                    }

                    self?.performDataUpdate(at: indexPath.row, with: newName)
                    self?.retrieve()
                    self?.tableView.reloadData()
                }

                alertController.addAction(cancelAction)
                alertController.addAction(updateAction)

                present(alertController, animated: true)
    }

    func handleMoveToTrash(indexPath: IndexPath) {
        self.pokemonModel.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        let ifFavorite = isFavorite(pokemonModel[indexPath.row].pokeName)
        let favoritePoke = ifFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        detailController?.favoriteButton.setImage(favoritePoke, for: .normal)
    }

    func isFavorite(_ name: String) -> Bool{
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return false }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokeFav")
        fetchRequest.predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.fetchLimit = 1
        
        do{
            let count = try managedContext.count(for: fetchRequest)
            return count > 0
        }catch let error{
            print("Failed to fetch data", error)
            return false
        }
        
    }
    
    private func retrieve(){
        
        //array model
        var poke = [PokemonModel]()
        
        //managed context
        let managedContext = appDelegate?.persistentContainer.viewContext
        //fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokeFav")
        do{
            let result = try managedContext?.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { user in
                guard let pokemon = user as? PokeFav else { return }
                let getPoke = PokemonModel(pokeName: pokemon.pokeName ?? "", id: Int(pokemon.id))
                poke.append(getPoke)
            }
            pokemonModel = poke

        } catch let error{
            print("Failed to fetch data", error)
        }
    }
    private func delete(_ name: String, indexPath: IndexPath){
        //managed context
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        //fetch data to edit
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PokeFav")
        fetchRequest.predicate = NSPredicate(format: "pokeName = %@", name)

        do{
            let result = try managedContext.fetch(fetchRequest)

            for index in 0..<result.count{
                let dataToDelete = result[index] as! NSManagedObject
                managedContext.delete(dataToDelete)
                try managedContext.save()
                print("DeleteUser", dataToDelete)
                retrieve()
                tableView.reloadData()
            }



        }catch let error{
            print("Unable to delete data", error)
        }
    }
    func performDataUpdate(at index: Int, with newName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "PokeFav")
            
            do {
              let fetchedResults = try managedContext.fetch(fetchRequest)
                let dataToUpdate = fetchedResults[index] as! NSManagedObject
              
              if let pokemon = fetchedResults.first {
                dataToUpdate.setValue(newName, forKey: "pokeName")
                
                do {
                  try managedContext.save()
                  print("Data updated successfully")
                } catch{
                  print("Failed to update data: (error), (error.userInfo)", error)
                }
              }
            } catch {
              print("Fetch error: (error), (error.userInfo)", error)
            }
            isChange = true
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        retrieve()
        cell.moveLabel.text = pokemonModel[indexPath.row].pokeName
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pokeModel = pokemonModel[indexPath.row]
        let trash = UIContextualAction(style: .destructive,
                                       title: "Trash") { [weak self] (action, view, completionHandler) in
            self?.delete(pokeModel.pokeName, indexPath: indexPath)
                                        completionHandler(true)
            
        }
        let update = UIContextualAction(style: .normal,
                                       title: "Update") { [weak self] (action, view, completionHandler) in
                                        self?.handleUpdate(indexPath: indexPath)
                                        completionHandler(true)
        }
        update.backgroundColor = .systemOrange
            let configuration = UISwipeActionsConfiguration(actions: [trash, update])
            return configuration
        }
    
        
    }

