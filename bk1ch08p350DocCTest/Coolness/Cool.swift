//
//  Cool.swift
//  Coolness
//
//  Created by Matt Neuburg on 6/26/21.
//

import UIKit


/// Degree of coolness.
public enum Temp {
    /// So cool you could plotz.
    case frigid
    /// Kind of cool.
    case lukewarm
    /// Not particularly cool.
    case boiling
}


/// Expression of coolness.
public struct Cool {
    var temp : Temp
    
    /// Changes our coolness.
    /// - Parameter to: The ``Temp`` you'd like it to be.
    public mutating func changeTemp(to: Temp) {
        
    }
}
