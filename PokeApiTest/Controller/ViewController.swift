//
//  ViewController.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 12/07/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    
    var subPoke = [SubPokeModel]()
    var networks = Network()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        networks.fetchAPIPoke{ subPokemon in
            self.subPoke.append(contentsOf: subPokemon.results)
            self.collectionView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(subPoke.count)
        return subPoke.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        let imageUrlString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(indexPath.item + 1).png"
        if let imageUrl = URL(string: imageUrlString){
            DispatchQueue.global().async{
                if let imageData = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: imageData){
                    DispatchQueue.main.async {
                        if collectionView.indexPath(for: cell) == indexPath{
                            cell.pokemonImage.image = image
                        }
                    }
                }
            }
        }
        
        
        cell.pokemonName.text = subPoke[indexPath.row].name
        return cell
   }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailPokeViewController") as? DetailPokeViewController else { return }
        
        let imageUrlString = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(indexPath.item + 1).png")!
        let poke = subPoke[indexPath.row]
        vc.imageUrls = imageUrlString
        vc.nameLabel = poke.name
        vc.url = poke.url
        

        vc.configure(pokeData: poke)
        
        let call = subPoke[indexPath.row]
        guard let basic = storyboard.instantiateViewController(withIdentifier: "BasicInfoViewController") as? BasicInfoViewController else { return }
        basic.configure(url: call.url)
//        basic.namePokemon = poke.name
        guard let move = storyboard.instantiateViewController(withIdentifier: "MovesViewController") as? MovesViewController else { return }
        move.configure(move: call.url)
        guard let stat = storyboard.instantiateViewController(withIdentifier: "StatViewController") as? StatViewController else { return }
        stat.configure(stat: call.url)
        navigationController?.pushViewController(vc, animated: true)
        
    }


}

