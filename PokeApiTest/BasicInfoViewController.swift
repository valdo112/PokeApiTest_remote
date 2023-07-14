//
//  BasicInfoViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 14/07/23.
//

import UIKit

var linkBasic = ""

class BasicInfoViewController: UIViewController {
    
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var abilitiesName: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var networks = Network()
    private var ability = [Ability]()
    private var typeDetails = [TypeDetails]()
    private var detailPokemon: DetailPokemon?
    
    func configure(url: String){
        linkBasic = url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(linkBasic)
        networks.fetchAPIPokeAbilities(pokeAbilitiesLink: linkBasic) { abilities in
            self.ability.append(contentsOf: abilities.abilities)
            self.typeDetails.append(contentsOf: abilities.types)
            self.detailPokemon = abilities
            self.abilitiesName.text = self.ability.map({$0.ability.name.capitalized}).joined(separator: ", ")
            self.typesLabel.text = self.typeDetails.map({$0.type.name.capitalized}).joined(separator: ", ")
            self.heightLabel.text = "\(self.detailPokemon!.height)"
            self.weightLabel.text = "\(self.detailPokemon!.weight)"

        }
    }
}
