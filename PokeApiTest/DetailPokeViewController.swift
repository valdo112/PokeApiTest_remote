//
//  DetailPokeViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 12/07/23.
//

import UIKit
import SDWebImage

class DetailPokeViewController: UIViewController {
    var nameLabel: String = ""
    var url: String = ""
    var imageUrls: URL!
    var containerAbilities = ""
    
    private var model: SubPokeModel?
    private var networks = Network()
    private var ability = [Ability]()
    private var typeDetails = [TypeDetails]()
    private var detailPokemon: DetailPokemon?
    
    @IBOutlet weak var segmentViewStat: UIView!
    @IBOutlet weak var segmentViewMoves: UIView!
    @IBOutlet weak var segmentViewBasicInfo: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var imageControl: UISegmentedControl!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonAbility: UILabel!
    @IBOutlet weak var pokemonName: UILabel! {
        didSet{
            pokemonName.text = nameLabel.capitalized
        }
    }
    func configure(pokeData: SubPokeModel){
        model = pokeData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(segmentViewBasicInfo)

        networks.fetchAPIPokeAbilities(pokeAbilitiesLink: url) { detailPokemon in
            self.detailPokemon = detailPokemon
            print("data URL : \( self.detailPokemon?.sprites)")
            print("data URL : \( self.detailPokemon?.weight)")
//            self.weightLabel.text = "\(self.detailPokemon!.weight)"
//            self.heightLabel.text = "\(self.detailPokemon!.height)"
            DispatchQueue.main.async {
                let unwrapValue = self.detailPokemon?.sprites.frontDefault
                guard let urlImage =  URL(string: unwrapValue!) else { return }
                self.pokemonImage.sd_setImage(with: urlImage)
            }
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







