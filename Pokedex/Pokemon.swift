//
//  Pokemon.swift
//  Pokedex
//
//  Created by Hannan Saleemi on 27/12/2016.
//  Copyright © 2016 Hannan Saleemi. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    private var _pokedexId: Int!
    
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    var nextEvolutionText: String{                              //Data hiding/protection
        
        if _nextEvolutionTxt == nil{                            //If it has no value
            
            _nextEvolutionTxt = ""                              //Instead of a crash, send an empty string
            
        }
        return _nextEvolutionTxt                                //If there is a value then just return that
    }

    
    var nextEvolutionName: String{
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionID: String{
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    
		
    
    var name: String{
        return _name
    }
    
    var pokedexId: Int{
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
        
        
        
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        //Tell alamorefire which like to follow
        Alamofire.request(_pokemonURL).responseJSON { response in
            
        
            if let dict = response.result.value as? Dictionary<String, AnyObject>{      //Dictionary with whole request inisde
            
                if let weight = dict["weight"] as? String {                             //Search for weight
                    
                    self._weight = weight                                               //assign value to weight var
                    
                }
                
                if let height = dict["height"] as? String {                             //Search for height
                    
                    self._height = height                                               //assign value to height var
                    
                }
                
                if let attack = dict["attack"] as? Int{                              //Search for attack
                    
                    self._attack = "\(attack)"                                               //assign value to attack var
                    
                }
                
                if let defense = dict["defense"] as? Int{                            //Search for defense
                    
                    self._defense = "\(defense)"                                     //assign value to defense var
                    
                }
                
                print(self._weight)
                print(self._height)
                print(self._defense)
                print(self._attack)
                
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {    //search type, make sure there is at least one type in there (, types.count > 0) means (where types.count > 0) (, means where)
                    
                    if let name = types[0]["name"]{
                        
                        self._type = name.capitalized
                        
                    }
                    
                    if types.count > 1{                             //If there are more than one types
                        
                        for x in 1..<types.count{                   //For x in 1 to less that number or items in arrya types
                            
                            if let name = types[x]["name"]{         //Grab the name and next position
                                
                                self._type! += "/\(name.capitalized)"    //Add onto previous type with a / as a seperator
                                
                            }
                            
                        }
                        
                    }
                    
                    print(self._type)
                    
                    
                }else{
                    
                    self._type = ""
                    
                }
                
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0{     //description
                    
                    if let url = descArr[0]["resource_uri"]{                                //stores url for description
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON{ response in                  //goto seperate api to get description
                            
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject>{
                                
                                if let desc = descDict["description"] as? String{
                                    
                                    let newDescription = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")   //replace spelling err
                                    
                                    self._description = newDescription
                                    
                                }
                                
                            }
                            completed()
                            
                        }
                        
                    }
                    
                }else {
                    
                    self._description = ""
                    
                }
                
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvo = evolutions[0]["to"] as? String{
                        
                        if nextEvo.range(of: "mega") == nil {
                            
                            self._nextEvolutionName = nextEvo
                            
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionID = nextEvoID
                                
                                if let lvlExist = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExist as? Int{
                                        
                                        self._nextEvolutionLevel = "\(lvl)"
                                        
                                    }
                                    
                                }else{
                                    
                                    self._nextEvolutionLevel = ""
                                    
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    print(self.nextEvolutionName)
                    print(self.nextEvolutionID)
                    print(self.nextEvolutionLevel)
                    
                }
                
                
            }
            
            completed()
            
        }
        
    }
    
}
