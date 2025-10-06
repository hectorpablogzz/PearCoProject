//
//  CaficultorSheet.swift
//  CRUD
//
//  Created by Héctor Pablo González on 25/09/25.
//

import SwiftUI
import SwiftData

struct CaficultorSheet: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Binding var caficultor: Caficultor
    @EnvironmentObject var VM: CaficultorViewModel
    
    
    
    // Default if Caficultor is new
    var isNew : Bool = true
    
    // Title of the form depending on the scenario
    var title: String { isNew ? "Nuevo Caficultor" : "Editar Caficultor" }
    
    
    
    
    
    
    var body: some View {
        NavigationStack{

            
            Form{
                Text("Campos con asterisco (*) son obligatorios.")
                    

                TextField("Nombre(s)*", text: $caficultor.name)
                
                TextField("Apellido(s)*", text: $caficultor.lastname)
                
                DatePicker("Fecha de Nacimiento*", selection: $caficultor.birthDate, displayedComponents: .date)
                
                Picker("Sexo*", selection: $caficultor.gender) {
                    Text("Masculino").tag("M")
                    Text("Femenino").tag("F")
                    Text("Prefiero no decir").tag("X")
                }
                
                TextField("Núm. de teléfono", text:$caficultor.telephone)
                    .keyboardType(.numberPad)
                
                TextField("Correo electrónico", text:$caficultor.email)
                    .keyboardType(.emailAddress)
                
                TextField("Dirección*", text:$caficultor.address)
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading){
                    Button("Cancelar"){
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing){

                    Button("Guardar") {
                        // Validate if all fields are correct
                        guard Caficultor.isValid(caficultor: caficultor) else { return }
                        
                        // save if it's new
                        if(isNew) {
                            Task {
                                await VM.addCaficultor(caficultor)
                            }
                        }
                        else {
                            Task {
                                await VM.updateCaficultor(caficultor)
                            }
                        }
                    dismiss()
                    }
                    .disabled(!Caficultor.isValid(caficultor: caficultor))
                }
            }
        }
            
    }
}

