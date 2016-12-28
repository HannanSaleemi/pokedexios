//
//  PokeCell.swift
//  Pokedex
//
//  Created by Hannan Saleemi on 27/12/2016.
//  Copyright © 2016 Hannan Saleemi. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!                                   //These vars are the stuff inside the collection view cell
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!                                                       //Pokemon class (blueprint)
    
    required init?(coder aDecoder: NSCoder){                                    //Round the cells
        
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        
    }
    
    func configureCell(_ pokemon: Pokemon) {                                      //Create custom Cell for collection view and contenty of cell
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    
    }
    
    
    
}
