//
//  StatViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 14/07/23.
// comment for commit

import UIKit

var linkurl = ""

class StatViewController: UIViewController {

    @IBOutlet weak var hpProgress: UIProgressView!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!

    @IBOutlet weak var defenseProgress: UIProgressView!
    @IBOutlet weak var attackProgress: UIProgressView!
    
    private var networks = Network()
    private var ability = [Ability]()
    private var typeDetails = [TypeDetails]()
    private var detailPokemon: DetailPokemon?
    
    
    func configure(stat: String){
        linkurl = stat
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networks.fetchAPIPokeAbilities(pokeAbilitiesLink: linkUrl) { detailPokemon in
            self.detailPokemon? = detailPokemon
            self.hpLabel.text = "\(detailPokemon.stats[0].base_stat)"
            self.attackLabel.text = "\(detailPokemon.stats[1].base_stat)"
            self.defenseLabel.text = "\(detailPokemon.stats[2].base_stat)"
            self.hpProgress.progress = Float(detailPokemon.stats[0].base_stat)/100
            self.attackProgress.progress = Float(detailPokemon.stats[1].base_stat)/100
            self.defenseProgress.progress = Float(detailPokemon.stats[2].base_stat)/100

        }
       
    }
    
}
