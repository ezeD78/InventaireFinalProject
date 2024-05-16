//
//  VueItems.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 25/03/2024.
//

import SwiftUI

struct VueItems: View {
    @Binding var items: [Item]
    @Binding var removeItem: [Item]
    @Binding var selection: Int
    @State var qte = false

    var body: some View {
        if selection == 0 {
            ForEach(items.indices, id: \.self) { index in

                HStack {

                        Text(items[index].unite.description).font(.system(size: 17))

                    AsyncImage(url: URL(string: items[index].urlImage)) { image in
                        image.resizable().scaledToFit().frame( maxWidth: 100, maxHeight: 85, alignment: .center)

                    }placeholder: {
                        ProgressView()
                    }

                    VStack {
                        HStack {

                            Text(items[index].nom).bold().font(.system(size: 18))
                        }

                        HStack {
                            Text(items[index].marque).font(.system(size: 11))
                            Text(items[index].quantite).font(.system(size: 11))
                        }

                        if items[index].dateOuverture != nil {
                            Spacer()
                            Text("Ouvert depuis \(items[index].depuisQuand()), jours ").font(.system(size: 13))
                        }

                    }

                    //  Text ("\(items[i].quantite.description) \(items[i].unite)")
                    if items[index].dlc != nil {
                        Text(items[index].dlc!.formatted(date: .numeric, time: .omitted))
                    }
                    Spacer()
                    Menu {
                        Button(action: {
                            items[index].unite += 1
                        }, label: {
                            Label("Ajouter une quantité", systemImage: "plus.circle")
                        })
                        Button(action: {
                            if items[index].unite == 1 {
                                removeItem.append(items[index])
                                items.remove(at: index)
                            } else {
                                items[index].unite -= 1
                            }
                        }, label: {
                            Label("Supprimer une quantité", systemImage: "minus.circle")
                        })

                        Button(action: {
                            items[index].dateOuverture = Date()
                        }, label: {
                            Label("Noter l'ouverture du produit", systemImage: "square.and.pencil.circle")
                        })

                    } label: {
                        Image(systemName: "info.circle").resizable().scaledToFit().frame(maxHeight: 30)

                    }
                }

            }.onDelete { index in
                deleteProduit(index)

            }
        } else {
            ForEach(removeItem.indices, id: \.self) { index in
                HStack {
                    AsyncImage(url: URL(string: removeItem[index].urlImage)) { image in
                        image.resizable().scaledToFit().frame(height: 85)

                    }placeholder: {
                        ProgressView()
                    }
                    Spacer(minLength: 30)

                    VStack {
                        HStack {
                            Text(removeItem[index].nom).bold().font(.system(size: 18)).foregroundStyle(Color(.red))
                        }

                        HStack {
                            Text(removeItem[index].marque).font(.system(size: 11)).foregroundStyle(Color(.red))
                            Text(removeItem[index].quantite).font(.system(size: 11)).foregroundStyle(Color(.red))
                        }

                    }

                    //  Text ("\(items[i].quantite.description) \(items[i].unite)")
                    if removeItem[index].dlc != nil {
                        Text(removeItem[index].dlc!.formatted(date: .numeric, time: .omitted))
                    }

                }

            }

        }

    }
    func deleteProduit(_ index: IndexSet) {
        let indexes = Array(index)

        // Parcourir les indexes pour ajouter les éléments à removeItem
        for index in indexes {
            if index < items.count {
                removeItem.append(items[index])
            }
        }
        // removeItem.append(items.inde)
        items.remove(atOffsets: index)
    }
}

// #Preview {
//    VueItems()
// }
