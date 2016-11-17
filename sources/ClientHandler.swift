//
//  ClientHandlerThread.swift
//  chatd
//
//  Created by Stephen Brimhall on 11/15/16.
//
//

import Foundation
import Socks

public class ClientHandler: Thread, MessageSource {
    
    private let client: TCPClient;
    
    public var colorCode = ShellColor.Default;
    public let id: Int;
    
    public init(client: TCPClient, id: Int) {
        self.client = client;
        self.id = id;
        
        super.init();
    }
    
    public override func main() {
        while true {
            do {
                var message = try client.receiveAll();
                if message.count < 2 {
                    continue;
                }
                /*
                if message[0] == 2 {
                    message.remove(at: 0);
                    if message[message.count - 1] == 3 {
                        message.removeLast();
                        if let text = String.fromBytes(message) {
                            for client in Server.clients {
                                client.sendMessage(message: text, client: self);
                            }
                        }
                    }
                }
                */
                
                if let text = String.fromBytes(message) {
                    for client in Server.clients {
                        client.sendMessage(message: text, client: self);
                    }
                }
            } catch {
                return;
            }
        }
    }
    
    public func sendMessage(message: String, client source: MessageSource) {
        
        if source.id == self.id {
            return;
        }
        
        let message = source.colorCode.rawValue + message + ShellColor.Default.rawValue;
        
        do {
            try client.send(bytes: message.toBytes());
        } catch {
        }
    }
}

public protocol MessageSource {
    var colorCode: ShellColor {get}
    var id: Int {get}
}
