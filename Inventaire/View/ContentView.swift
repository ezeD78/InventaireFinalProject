//
//  ContentView.swift
//  Inventaire
//
//  Created by Ezequiel Gomes on 14/03/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Query  var maisons: [Maison]
    @State var ajout = false
    @EnvironmentObject var check: CheckScannerDispo
    @Environment(\.modelContext) var context
    @State var editing = false
    @State private var nomMaison = ""
    @State var maison: Maison?
    @State var espaces: [EspaceModel] = []
    @State private var isEditing = false

    var body: some View {
        VStack {
            if check.dataScannerAccessStatus == .scannerAvailable {
                VStack {

                    NavigationStack {
                        VStack {
                            if !maisons.isEmpty {
                                Text(maisons[0].nom).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).padding(.vertical, 13.0)
                                LazyVGrid(columns: [
                                    GridItem(),
                                    GridItem()
                                ]) {
                                    // Bon a savoir .indices plutôt que .count améliore les performance

                                    ForEach(espaces.indices, id: \.self) { index in
                                        NavigationLink(value: espaces[index] ) {
                                            Espaces(espaceModel: espaces[index]).padding(.bottom).foregroundColor(.white)
                                        }
                                        if isEditing {
                                            Button(action: {
                                                espaces.remove(at: index)
                                                maisons[0].espaces = espaces

                                            }, label: {
                                                Text("Suprimmer").foregroundStyle(Color(.red))
                                            })
                                        }
                                    }

                                }.padding(.top).navigationDestination(for: EspaceModel.self ) { index in
                                    ItemView(espace: index).padding(.bottom)
                                }

                                Spacer()
                                Button(action: {
                                    maison = maisons[0]
                                    ajout.toggle()
                                }, label: {
                                    Label("Ajouter une catégorie", systemImage: "plus.app").font(.system(size: 25))
                                }).toolbar(content: {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button(action: {
                                            isEditing.toggle()
                                        }, label: {
                                            Label("Menu", systemImage: "line.3.horizontal")
                                        })
                                    }
                                })

                                .onAppear {
                                    espaces = maisons[0].espaces
                                }.onChange(of: maisons[0].espaces) {
                                    espaces = maisons[0].espaces
                                }} else {
                                    VStack {
                                        Text("Comment s'appelle votre maison ?")
                                        TextField(text: $nomMaison) {
                                            Text("nom de votre maison ")
                                        }.onSubmit {

                                            context.insert(Maison(nom: nomMaison))
                                            //                                        try!
                                            //                                        context.save()

                                        }

                                    }
                                }
                        }
                    }
                }.sheet(item: $maison, content: { house in
                    AjoutEspace(maison: house)
                })
                //                    .sheet(isPresented: $ajout, content: {
                //                        //AjoutEspace(maison: $maison)
                //                       // AjoutEspace(maison: ).modelContainer(for : EspaceModel.self)
                //                    })

            } else {

                VStack {
                    Text("Votre configuration ne permet d'utiliser l'application").font(.title)
                    Text("Assurez vous d'avoir autorisé l'accès à la caméra pour pouvoir utiliser l'aplication")
                }.padding()
            }

        }

        // #Preview {
        //
        // }
    }
}
