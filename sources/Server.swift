//
//  Server.swift
//  chatd
//
//  Created by Stephen Brimhall on 11/8/16.
//
//

import Foundation
import Socks;

public class Server: MessageSource {
    private let tcpServer: SynchronousTCPServer
    private static var clientList: [ClientHandler] = [];
    public static var clients: [ClientHandler] {
      get {
        return clientList;
      }
    }
    public let colorCode = ShellColor.LightGray;
    public let id = 0;
    
    private var nextId = 1;
    
    public static var server: Server!;

    internal init() throws {
        tcpServer = try SynchronousTCPServer(port: 12346, bindLocalhost: false);
        Server.server = self;
    }

    internal func start() throws -> Never {
        try tcpServer.startWithHandler(handler: self.handler);
    }

    internal func handler(_ client: TCPClient) throws {
        // Add client handler to list
        Server.clientList.append(ClientHandler(client: client, id: nextId));
        
        // Increment nextId so that each client gets a unique id
        nextId += 1;
        
        // Recieve client's hello message, which will be treated as username.
        // TODO: Add security check
        //       Will request password after username, recieve hashed password, compare to entry in /etc/passwd
        let contactMessage = try client.receiveAll();
        
        let contactString: String;
        
        if let string = String.fromBytes(contactMessage) {
            contactString = string;
        } else {
            return;
        }
        
        for client in Server.clients {
            client.sendMessage(message: contactString, client: Server.server);
        }
        
        Server.clients.last!.start();
    }
}

public extension String {
    public static func fromBytes(_ bytes: [UInt8]) -> String? {
        let data = Data(bytes);
        return String(data: data, encoding: String.Encoding.ascii);
    }
}
