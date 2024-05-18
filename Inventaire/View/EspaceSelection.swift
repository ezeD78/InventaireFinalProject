//
//  EspaceSelection.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 16/05/2024.
//

import SwiftUI

struct EspaceSelection: View {
    // @State var espaces: [EspaceModel]
    @State var maison: Maison

    var body: some View {
        Text("kkp^k")
      //  EspacesDisplay(espaces: $maison.espaces)
    }
}

struct Espaces: View {
    var espaceModel: EspaceModel

    var body: some View {

        ZStack {

            Circle().foregroundStyle(espaceModel.getColor())
            VStack {
                Image(systemName: espaceModel.imageName).resizable().scaledToFit().frame(width: 45)
                Text(espaceModel.nom).font(.system(size: 13))
            }

        }.frame(width: 140)
    }
}
struct EspacesDisplay: View {
    @State var espaces: [EspaceModel]
    @State  var editing = false

    var body: some View {

        VStack {

            NavigationStack {
                VStack {
                    LazyVGrid(columns: [
                        GridItem(),
                        GridItem()
                    ]) {
                        // Bon a savoir .indices plutôt que .count améliore les performance

                        ForEach(espaces.indices, id: \.self) { index in
                            VStack {
                                NavigationLink(value: espaces[index] ) {
                                    Espaces(espaceModel: espaces[index]).padding(.bottom).foregroundColor(.white)
                                }
                                if editing {
                                    Button(action: {
                                        espaces.remove(at: index)
                                        editing.toggle()

                                    }, label: {
                                        Text("Supprimer").foregroundStyle(Color(.red)).font(.system(size: 22.0))
                                    })
                                }
                            }

                        }

                    }.padding(.top).navigationDestination(for: EspaceModel.self ) { espace in
                        ItemView(espace: espace).padding(.bottom)
                    }

                    Spacer()
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {

                                    editing.toggle()
                                }, label: {
                                    Label("Menu", systemImage: "line.3.horizontal")
                                })
                            }
                        })

                }
            }//            .onChange(of: indexToDelete) {
            //                if let index = indexToDelete {
            //                    espaces.remove(at: index)
            //                }
            //                indexToDelete = nil
            //            }

        }
    }
}
