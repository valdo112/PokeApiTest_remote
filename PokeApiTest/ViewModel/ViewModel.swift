//
//  ViewModel.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 20/07/23.
//

import UIKit
import CoreData


struct ViewModel{
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var pokemonModel: [PokemonModel] = []

func create(_ name: String, _ id: Int){
    
    
    //Managed Context
   guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
    //Referensi entity yang telah dibuat sebelumnya
    let userEntity = NSEntityDescription.entity(forEntityName: "PokeFav", in: managedContext)
    //Entity body
    let insert = NSManagedObject(entity: userEntity!, insertInto: managedContext)
    insert.setValue(name, forKey: "pokeName")
    insert.setValue(id, forKey: "id")
    do{
        //save data ke entity user core data
        try managedContext.save()
        print("Save data into core data")
        
    } catch let err{
        print("Failed to save data", err)
    }
}
 func checkData(_ name: String, completion: @escaping (Bool) -> Void) {
  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
  let manageContext = appDelegate.persistentContainer.viewContext
  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PokeFav")
  fetchRequest.predicate = NSPredicate(format: "pokeName = %@", name)
  
  do {
    let result = try manageContext.fetch(fetchRequest)
    let isExist = result.count > 0
    completion(isExist)
  } catch {
    
  }
}
    mutating func delete(_ name: String){
    guard let appDelegeate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegeate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PokeFav")
        fetchRequest.predicate = NSPredicate(format: "pokeName = %@", name)
        
        do {
          let result = try managedContext.fetch(fetchRequest)
          
          for index in 0..<result.count {
            let dataToDelete = result[index] as! NSManagedObject
            managedContext.delete(dataToDelete)
            try managedContext.save()
            retrieve()
          }
        } catch let err {
          print("Unable to update data: ",err)
        }
}
    mutating func retrieve(){
    
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
    mutating func delete(_ name: String, indexPath: IndexPath){
    //managed context
    guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
    //fetch data to edit
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "PokeFav")
    fetchRequest.predicate = NSPredicate(format: "pokeName = %@", name)
    
    do{
        let result = try managedContext.fetch(fetchRequest)
        
//                let dataToDelete = result[indexPath] as! NSManagedObject
        for index in 0..<result.count{
            let dataToDelete = result[index] as! NSManagedObject
            managedContext.delete(dataToDelete)
            try managedContext.save()
            print("DeleteUser", dataToDelete)
            retrieve()
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
}
