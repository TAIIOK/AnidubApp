//
//  CollectionviewSearch.swift
//  DubAnime
//
//  Created by Roman Efimov on 21/05/2019.
//  Copyright © 2019 Roman Efimov. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func enable() {
        isUserInteractionEnabled = true
        alpha = 1.0
    }
    
    func disable() {
        isUserInteractionEnabled = false
        alpha = 0.5
    }
}

class CollectionviewSearch: UICollectionReusableView{
    
    @IBOutlet var SearchBar: UISearchBar!
    
    
    func search(status:Bool){
        if(status){
        SearchBar.enable()
        }else{
            SearchBar.disable()
        }
    }
    
    
}
