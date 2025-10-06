//
//  CaficultoresView.swift
//  PearCoProject
//
//  Created by Héctor Pablo González on 05/10/25.
//

import SwiftUI

struct CaficultorRow: View {
    let c: Caficultor
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

struct CaficultorView: View {
    @State private var isShowingItemSheet = false
    
    @State private var caficultorToEdit: Caficultor?
    @State private var searchText: String = ""
    
    @StateObject private var VM = CaficultorViewModel()
    @State private var newCaficultor = Caficultor(name: "", lastname: "", birthDate: Date(), gender: "X", telephone: "", email: "", address: "")
    
    private var filteredCaficultores: [Caficultor] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return VM.caficultores }
        return VM.caficultores.filter { c in
            c.name.lowercased().contains(q) ||
            c.lastname.lowercased().contains(q) ||
            c.email.lowercased().contains(q) ||
            c.telephone.lowercased().contains(q) ||
            c.address.lowercased().contains(q)
        }
    }
    
    var body: some View {
        
        VStack() {
            Text("Caficultores")
                .font(.system(size: 55, weight: .bold))
                .padding(15)
                .padding(.top, 20)
                .foregroundColor(Color.verdeOscuro)
            ZStack {
                Color.grisFondo
                    .edgesIgnoringSafeArea(.all)
                NavigationStack {
                    
                    VStack(spacing: 0) {
                        
                        if VM.hasError {
                            Text("Error obteniendo caficultores.")
                                .foregroundStyle(.red)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.horizontal)
                        }
                        List {
                            if !filteredCaficultores.isEmpty {
                                ForEach(filteredCaficultores) { caficultor in
                                    CaficultorRow(c: caficultor)
                                        .contentShape(Rectangle())
                                        .onTapGesture { caficultorToEdit = caficultor }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button(role: .destructive) {
                                                Task { await VM.deleteCaficultor(caficultor) }
                                            } label: {
                                                Label("Eliminar", systemImage: "trash")
                                            }
                                            Button {
                                                caficultorToEdit = caficultor
                                            } label: {
                                                Label("Editar", systemImage: "pencil")
                                            }
                                        }
                                }
                            }
                        }
                        .background(Color.grisFondo)
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .refreshable { try? await VM.getCaficultores() }
                        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
                        
                        
                    }
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isShowingItemSheet = true
                            } label: {
                                Label("Agregar", systemImage: "plus")
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack {
                        Spacer()
                        MicrophoneButton(color: Color.verdeOscuro)
                            .padding(.trailing, 16)
                    }
                    .padding(.bottom, 16)
                    .background(Color.clear)
                }
            }
            
        }
        .background(Color.grisFondo)
        .sheet(isPresented: $isShowingItemSheet) {
            CaficultorSheet(caficultor: $newCaficultor, isNew: true)
        }
        .sheet(item: $caficultorToEdit) { caficultor in
            if let index = VM.caficultores.firstIndex(where: { $0.id == caficultor.id }) {
                CaficultorSheet(
                    caficultor: Binding(
                        get: { VM.caficultores[index] },
                        set: { VM.caficultores[index] = $0 }
                    ),
                    isNew: false
                )
            } else {
                Text("No se encontró el caficultor seleccionado.")
            }
        }
        .environmentObject(VM)
        .task {
            do {
                try await VM.getCaficultores()
            } catch {
                VM.hasError = true
            }
        }
    }
}

#Preview {
    CaficultorView()
}
