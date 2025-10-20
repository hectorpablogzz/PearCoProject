//
//  ContentView.swift
//  DataPersistenceDB
//
//  Created by Héctor Pablo González on 19/10/25.
//

import SwiftUI
import SwiftData

struct CaficultorView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CaficultorModel.name) private var caficultores: [CaficultorModel]
    
    @StateObject private var VM = CaficultorVM()
    
    @State private var isShowingItemSheet = false
    @State private var caficultorToEdit: CaficultorModel?
    
    var body: some View {
        ZStack {
            Color.grisFondo
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("Caficultores")
                                .font(.system(size: 55, weight: .bold))
                                .padding(15)
                                .padding(.top, 20)
                                .foregroundColor(Color.verdeOscuro)
                if(!VM.isConnected) {
                    Text("Modo sin conexión: No se podrán ver, agregar, editar o eliminar caficultores hasta que se reconecte.")
                        .font(.headline)
                }
                    
                                
                NavigationStack {
                    List {
                        ForEach(caficultores) { caficultor in
                            CaficultorRow(c: caficultor)
                                .onTapGesture {
                                    if(VM.isConnected) {
                                        caficultorToEdit = caficultor
                                    }
                                }
                                
                                
                        }
                        
                        .onDelete { indexSet in
                            for index in indexSet {
                                modelContext.delete(caficultores[index])
                                // Call VM to delete caficultor
                                Task {
                                    await VM.deleteCaficultor(caficultores[index].id)
                                }
                            }
                        }
                    }
                    
                    .scrollContentBackground(.hidden)
                    .background(Color.grisFondo)
                    .sheet(isPresented: $isShowingItemSheet) {
                        CaficultorSheet()
                    }
                    .sheet(item: $caficultorToEdit) { caficultor in
                        CaficultorSheet(caficultor: caficultor, isNew: false)
                    }
                    .toolbar {
                        Button("Agregar", systemImage: "plus") {
                            isShowingItemSheet = true
                        }
                        .disabled(!VM.isConnected)
                    }
                    
                }
                .background(Color.grisFondo)
                .task(priority: .userInitiated) {
                    if(VM.isConnected) {
                        let container = modelContext.container
                        let bgActor = CaficultorModel.BackgroundActor(modelContainer: container)
                        
                        do {
                            try await bgActor.importCaficultores()
                        
                            
                        } catch {
                            print("Error importing caficultores: \(error)")
                        }
                    }
                    
                    print(caficultores)
                }
            }
            MicrophoneButton(color: Color.verdeOscuro)
        }
        
    }
}

struct CaficultorRow: View {
    let c: CaficultorModel
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .foregroundColor(.verdeOscuro)
                .background(Color.white)
                .clipShape(Circle())
                .font(Font.largeTitle.bold())
            VStack(alignment: .leading, spacing: 2) {
                Text("\(c.name) \(c.lastname)")
                    .font(.headline)
                if !c.email.isEmpty {
                    Text(c.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if !c.telephone.isEmpty {
                    Text(c.telephone)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(c.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(c.gender)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.thinMaterial, in: Capsule())
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    CaficultorView()
        .modelContainer(for: [CaficultorModel.self], inMemory: true)
}
