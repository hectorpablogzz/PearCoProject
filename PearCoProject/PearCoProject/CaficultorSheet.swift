//
//  CaficultorSheet.swift
//  DataPersistenceDB
//
//  Created by Héctor Pablo González on 19/10/25.
//

import SwiftUI
import SwiftData

struct CaficultorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var context
    
    @ObservedObject var VM = CaficultorVM()
    
    // Default Caficultor with blank values
    @Bindable var caficultor = CaficultorModel(name: "", lastname: "", birthDate: .now, gender: "", telephone: "", email: "", address: "")
    
    // Default if Caficultor is new
    var isNew : Bool = true
    
    // Title of the form depending on the scenario
    var title : String {
        if(isNew) {
            "Nuevo Caficultor"
        }
        else {
            "Editar Caficultor"
        }
    }
    
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
                
                TextField("Núm. de teléfono*", text:$caficultor.telephone)
                    .keyboardType(.numberPad)
                
                TextField("Correo electrónico*", text:$caficultor.email)
                    .keyboardType(.emailAddress)
                
                TextField("Dirección*", text:$caficultor.address)
                
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancelar"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing){

                    Button("Guardar") {
                        // Validate if all fields are correct
                        guard CaficultorModel.isValid(caficultor: caficultor) else { return }
                        
                        // save if it's new
                        if(isNew) {
                            print(caficultor.name)
                            Task {
                                await VM.addCaficultor(Caficultor(id: caficultor.id, name: caficultor.name, lastname: caficultor.lastname, birthDate: caficultor.birthDate, gender: caficultor.gender, telephone: caficultor.telephone, email: caficultor.email, address: caficultor.address))
                            }
                            context.insert(caficultor)
                            try? context.save()
                        }
                        else {
                            print(caficultor.name)
                            Task {
                                await VM.updateCaficultor(Caficultor(id: caficultor.id, name: caficultor.name, lastname: caficultor.lastname, birthDate: caficultor.birthDate, gender: caficultor.gender, telephone: caficultor.telephone, email: caficultor.email, address: caficultor.address))
                            }
                        }
                    dismiss()
                    }
                    .disabled(!CaficultorModel.isValid(caficultor: caficultor))
                }
            }
        }
    }
}

#Preview {
    CaficultorSheet()
}

