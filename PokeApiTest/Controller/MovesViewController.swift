//
//  MovesViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 14/07/23.
//

import UIKit

var linkUrl = ""
class MovesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    func configure(move: String){
        linkUrl = move
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var move = [Move]()
    var detail: DetailAbility?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Network().fetchAPIPokeAbilities(pokeAbilitiesLink: linkUrl) { detailPokemon in
            self.move.append(contentsOf: detailPokemon.moves)
            self.tableView.reloadData()
        }
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        print("DATA = ", move.count)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        move.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.moveLabel.text = move[indexPath.row].move.name
        
        
        return cell
    }
}
