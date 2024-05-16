//
//  Scanner.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 23/03/2024.
//

import SwiftUI
import VisionKit
struct Scanner: View, UpdateProduitProtocol {

    func ajoutProduit(ean: String, produit: ItemData?) {
        if let safeProduit = produit {
            let itemAjout = Item(item: safeProduit)
            var produitIdentique: [Item] = []

            produitIdentique.append(contentsOf: produits.filter { item in
                item.ean == itemAjout.ean
            })

            if produitIdentique.count == 0 {
                produits.append(Item(item: safeProduit))
            } else {
                for index in produitIdentique {
                    produits.forEach { item in
                        if item.ean == index.ean {
                            item.unite += 1
                        }
                    }

                }

            }
            reconisedItem.removeAll()
            print("c'est ajoutéé ")

        } else {
            reconisedItem.removeAll()
            alert.toggle()
        }
    }

    @State var appelApi = AppelAPI()
    @State var alert = false
    @State var reconisedItem: [RecognizedItem] = []
    @State var produits: [Item] = []
    @State var produitsDeleted: [Item] = []
    @Binding var produitExport: [Item]
    @State var vue = 0
    // @EnvironmentObject var espaceModel: EspaceModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            DataScannerView(recognizedItems: $reconisedItem)
            Spacer()
            List {
                VueItems(items: $produits, removeItem: $produitsDeleted, selection: $vue)
            }
            Button("Terminer") {
                var produitIdentique: [Item] = []

                for index in produitExport.indices {

                    produitIdentique.append(contentsOf: produits.filter { ean in
                        ean.ean == produitExport[index].ean
                    })

                }

                for index in produitIdentique.indices {
                    produits.removeAll { item in
                        item.ean == produitIdentique[index].ean
                    }
                    produitExport.forEach { item in
                        if item.ean == produitIdentique[index].ean {
                            item.unite += produitIdentique[index].unite
                        }

                    }
                }

                produitExport.append(contentsOf: produits)
                dismiss()

            }

        }.onChange(of: reconisedItem, {
            if reconisedItem.isEmpty != true {
                switch reconisedItem[0] {
                case .barcode(let codeBarre):
                    if let codeSafe = codeBarre.payloadStringValue {
                        print(codeSafe)
                        appelApi.avoirInfoProduit(ean: codeSafe)

                    }
                default:
                    print("ok")
                }
            }

        }).onAppear {
            appelApi.delegate = self
        }.alert("Produit inconnu😢", isPresented: $alert) {
            Button("Ok") {

            }
        } message: {
            Text("Le produit n'est pas référencé dans la base de donnée, vous pouvez l'ajouter manuelment dans ajout d'un produit sans code barre ")
        }

    }

}
// #Preview {
//    Scanner()
// }
