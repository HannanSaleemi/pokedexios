//
//  ViewController.swift
//  Pokedex
//
//  Created by Hannan Saleemi on 27/12/2016.
//  Copyright © 2016 Hannan Saleemi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{

    
    @IBOutlet weak var collection: UICollectionView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!                              //IBACTION FOR SEARCHBAR
    
    var pokemon = [Pokemon]()
    
    var filteredPokemon = [Pokemon]()                                       //Search array
    var inSearchMode = false                                                //check if we are searching
    
    var musicPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        
        initAudio()

    }
    
    func initAudio(){                                                               //Auido Handling
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do{
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1                                          //Infinite Loop of audio
            musicPlayer.play()
            
        }catch let err as NSError{
            
            print(err.debugDescription)
            
        }
        
    
    }
    
    
    
    func parsePokemonCSV(){
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!             //Path for CSV file with pokemon data
        
        do{
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows                                                            //Parse CSV
            
            for row in rows{                                                                //FOR EACH ROW IN CSV
                
                let pokeId = Int(row["id"]!)!                                               //GET POKEID
                let name = row["identifier"]!                                               //GET NAME
                
                let poke = Pokemon(name: name, pokedexId: pokeId)                           //CREATE BLUEPRINT
                pokemon.append(poke)                                                        //APPEND TO ARRAY
                
            }
            
            
        }catch let err as NSError{
            
            print(err.debugDescription)
            
        }
        
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
            let poke: Pokemon!
            
            if inSearchMode {                                               //IF IN SERACH MODE (TRUE)
                
                poke = filteredPokemon[indexPath.row]                       //USE Filtered Pokemon List
                cell.configureCell(poke)                                    //Update cells with search results list
                
            }else{                                                          //IF NOT IN SEARCH MODE (FALSE)
                
                poke = pokemon[indexPath.row]                               //use original full pokemon list
                cell.configureCell(poke)                                    //Update cells with data
                
            }
            
            return cell
            
        }else{
            
            return UICollectionViewCell()
            
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        var poke: Pokemon!
        
        if inSearchMode{                                        //SearchMode If statement Check higher for description
            
            poke = filteredPokemon[indexPath.row]
            
        }else{
            
            poke = pokemon[indexPath.row]
            
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {       //items in collection section
        
        if inSearchMode {
            
            return filteredPokemon.count
            
        }
        
        return pokemon.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {                                 //number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {                        //define size of the cells
        
        return CGSize(width: 105, height: 105)
        
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {                    //Button press triggering playing or not player actions
        
        if musicPlayer.isPlaying{
            
            musicPlayer.pause()
            sender.alpha = 0.2                                              //Make translucent (styling) options
            
        }else{
            
            musicPlayer.play()
            sender.alpha = 1.0                                              //Make opaque (styling) options
            
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {          //When the search button on the keyboard is clicked
        
        view.endEditing(true)                                              //Hide the Keyboard
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {   //Anytime text is enetered in serachbar, this function is called
        
        if searchBar.text == nil || searchBar.text == "" {                      //nothing in searchbar or searchbar is empty
        
            inSearchMode = false                                                //disbale search mode
            collection.reloadData()                                             //reload original data
            view.endEditing(true)                                               //Hide the keyboard once were done
            
        }else{
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil}) //Each object in pokemon array, if text in searchbar matches, put into new pokemon array filteredPokemon
            
            collection.reloadData()                         //repopulate collection view with the serach results
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {                                  //If identifier of segue is PokemonDetailVC
            
            if let detailsVC = segue.destination as? PokemonDetailVC{
                
                if let poke = sender as? Pokemon{                                   //poke is the send or class Pokemon
                    
                    detailsVC.pokemon = poke                                        //View controller pass in var poke
                    
                }
                
            }
            
        }
        
    }

}



