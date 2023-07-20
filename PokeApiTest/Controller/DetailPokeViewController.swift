//
//  DetailPokeViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 12/07/23.
//

import UIKit
import SDWebImage
import CoreData

class DetailPokeViewController: UIViewController {
    var nameLabel: String = ""
    var url: String = ""
    var imageUrls: URL!
    var containerAbilities = ""
    var buttonActive = false
    var isExists: Bool = false
    
    private var subPokeModel: SubPokeModel?
    private var networks = Network()
    private var ability = [Ability]()
    private var typeDetails = [TypeDetails]()
    private var detailPokemon: DetailPokemon?
    var pokemonModel: [PokemonModel] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var viewModel = ViewModel()
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var segmentViewStat: UIView!
    @IBOutlet weak var segmentViewMoves: UIView!
    @IBOutlet weak var segmentViewBasicInfo: UIView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var imageControl: UISegmentedControl!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    func configure(pokeData: SubPokeModel){
        subPokeModel = pokeData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(segmentViewBasicInfo)
        tabBarController?.tabBar.isHidden = true
        networks.fetchAPIPokeAbilities(pokeAbilitiesLink: url) { detailPokemon in
            self.detailPokemon = detailPokemon

            DispatchQueue.main.async {
                let unwrapValue = self.detailPokemon?.sprites.frontDefault
                guard let urlImage =  URL(string: unwrapValue!) else { return }
                self.pokemonImage.sd_setImage(with: urlImage)
            }
            self.favoriteButton.isEnabled = false
            self.checkData(self.nameLabel) { [weak self] isExists in
                  self?.isExists = isExists
                let iconName = isExists ? "star.fill" : "star"
                    self?.favoriteButton.setImage(UIImage(systemName: iconName), for: .normal)
                  self?.favoriteButton.isEnabled = true
                }
        }
    }
    private func create(_ name: String, _ id: Int){
        
        
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
    private func checkData(_ name: String, completion: @escaping (Bool) -> Void) {
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
    private func delete(_ name: String){
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
    @IBAction func imageControlPressed(_ sender: UISegmentedControl) {
        switch imageControl.selectedSegmentIndex{
        case 0:
            let unwrapValue = self.detailPokemon?.sprites.frontDefault
            guard let urlImage =  URL(string: unwrapValue!) else { return }
            self.pokemonImage.sd_setImage(with: urlImage)
        case 1:
            let unwrapValue = self.detailPokemon?.sprites.frontShiny
            guard let urlImage =  URL(string: unwrapValue!) else { return }
            self.pokemonImage.sd_setImage(with: urlImage)
        default:
            break
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {

        networks.fetchAPIPokeAbilities(pokeAbilitiesLink: url) { detailPokemon in
            self.detailPokemon = detailPokemon
            
            guard let savingData = self.detailPokemon else {return}
            guard let savingName = self.subPokeModel?.name else {return}
            if self.isExists {
                self.delete(savingName)
                self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                } else {
                    self.create(self.nameLabel, detailPokemon.id)
                    self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
        }
//        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
//        create(nameLabel)
        
        
    }

    @IBAction func segmentViewPressed(_ sender: UISegmentedControl) {
        switch segmentView.selectedSegmentIndex{
        case 0:
            self.view.bringSubviewToFront(segmentViewBasicInfo)
            
        case 1:
            self.view.bringSubviewToFront(segmentViewMoves)
        case 2:
            self.view.bringSubviewToFront(segmentViewStat)
        default:
            break
        }
    }
    
    
}







