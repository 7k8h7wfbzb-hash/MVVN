//
//  ClienteFormularioView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct ClienteFormularioView: View {

    @Environment(\.dismiss) private var dismiss
    var viewModel: ClienteViewModel

    @State private var direccion = ""
    @State private var tipoCliente = "Regular"
    @State private var personaSeleccionada: Persona?

    private let tiposCliente = ["Regular", "VIP", "Corporativo"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Persona") {
                    if viewModel.personasDisponibles.isEmpty {
                        Text("No hay personas disponibles. Crea una persona primero.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Seleccionar persona", selection: $personaSeleccionada) {
                            Text("Ninguna").tag(nil as Persona?)
                            ForEach(viewModel.personasDisponibles, id: \.id) { persona in
                                Text("\(persona.nombre) \(persona.apellido)")
                                    .tag(persona as Persona?)
                            }
                        }
                    }
                }

                Section("Datos del Cliente") {
                    HStack {
                        TextField("Dirección", text: $direccion)
                        if !direccion.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    Picker("Tipo de Cliente", selection: $tipoCliente) {
                        ForEach(tiposCliente, id: \.self) { tipo in
                            Text(tipo)
                        }
                    }
                }
            }
            .navigationTitle("Nuevo Cliente")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        Task {
                            await viewModel.crearCliente(
                                direccion: direccion,
                                tipoCliente: tipoCliente,
                                persona: personaSeleccionada
                            )
                            if viewModel.mensajeError == nil {
                                dismiss()
                            }
                        }
                    }
                    .buttonStyle(.glass)
                }
            }
        }
    }
}
