//
//  AppelAPI.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 23/03/2024.
//

import Foundation

protocol UpdateProduitProtocol {
    func ajoutProduit(ean: String, produit: ItemData?)
}

class AppelAPI {
    var delegate: UpdateProduitProtocol?
    let debutUrl = "https://world.openfoodfacts.org/api/v2/product/"
    let finUrl = ".json"

    func avoirInfoProduit(ean: String) {
        let url = URL(string: debutUrl+ean+finUrl)
        // print(url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) {data, _, error in
            if error != nil {
                print(error?.localizedDescription)
                self.delegate?.ajoutProduit(ean: ean, produit: nil)
                return
            }

            if let safeData = data {

                self.delegate?.ajoutProduit(ean: ean, produit: self.parseJSON(safeData))

            }
        }
        task.resume()
    }

    func parseJSON(_ dataProduit: Data) -> ItemData? {
        var decodeData: ItemData?
        let decoder = JSONDecoder()
        do {
             decodeData = try decoder.decode(ItemData.self, from: dataProduit)
           // print (decodeData!.product.name_fr)
            if decodeData!.status == 0 {
                return nil

            } else {

                return decodeData
            }

        } catch {
            print("erreur JSON Decodage :" + error.localizedDescription)

        }
        return decodeData
    }
}
