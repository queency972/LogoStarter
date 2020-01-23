//
//  LogoService.swift
//  LogoViewer
//
//  Created by Steve Bernard on 19/01/2020.
//  Copyright © 2020 OpenClassrooms. All rights reserved.
//

import Foundation

class LogoService {
    // Instance unique.
    static let shared = LogoService()
    private init() {}

    // Creation d'un requete, instance URLSessionTask pour l'appel reseau
    private let baseUrl = "https://logo.clearbit.com/"
    private var task: URLSessionDataTask?

    func getLogo(domain: String, callback: @escaping (Bool, Data?) -> Void) {
        // On crée la tache.
        let session = URLSession(configuration: .default)

        guard let url = URL(string: baseUrl + domain) else {
            callback(false, nil)
            return
        }

        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                // On verifie qu'il y a des data.
                guard let data = data, error == nil,
                    // On verifie que nous avons une reponse qui a pour code 200.
                    let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                        callback(false, nil)
                        return
                }
                callback(true, data)
            }
        }
        // On lance la tache.
        task?.resume()
    }
}
