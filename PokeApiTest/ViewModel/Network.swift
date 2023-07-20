//
//  Network.swift
//  PokeApiTest
//
//  Created by Valdo Parlinggoman on 12/07/23.
//

import Foundation
import Alamofire


class Network{
    
    static let sharedInstance = Network()
    
    
    func fetchAPIPoke(completion: @escaping (PokeModel) -> Void){
        let url = "https://pokeapi.co/api/v2/pokemon?"
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response{ resp in
                switch resp.result{
                case .success(let data):
                    do{
                        let jSonData = try JSONDecoder().decode(PokeModel.self, from: data!)
//                        print(jSonData)
                        completion(jSonData)
                    } catch{
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
//    func fetchAPIPokeSpecies(speciesLink: String, completion: @escaping (Species) -> Void){
//        let url = speciesLink
//        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
//            .response{ resp in
//                switch resp.result{
//                case .success(let data):
//                    do{
//                        let jSonData = try JSONDecoder().decode(Species.self, from: data!)
//                        print(jSonData)
//                        
//                    } catch{
//                        print(error)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//    }
    func fetchAPIPokeAbilities(pokeAbilitiesLink: String, completion: @escaping (DetailPokemon) -> Void){
        let url = pokeAbilitiesLink
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response{ resp in
                switch resp.result{
                case .success(let data):
                    do{
                        let jSonData = try JSONDecoder().decode(DetailPokemon.self, from: data!)
//                        print("fetchAbilities=",jSonData)
                        completion(jSonData)
                    } catch{
                        print(error)
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
