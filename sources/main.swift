//
//  main.swift
//  chatd
//
//  Created by Stephen Brimhall on 11/8/16.
//
//

import Foundation
#if os(Linux)
import Glibc;
#else
import Darwin;
#endif


do {
    let server = try Server();
    
    try server.start();
    
} catch {
    
}
