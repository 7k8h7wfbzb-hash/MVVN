//
//  EmpleadoFormularioView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct EmpleadoFormularioView: View {

    @Environment(\.dismiss) private var dismiss
    var viewModel: EmpleadoViewModel

    @State private var cargo = ""
    @State private var departamento = ""
    @State private var salarioTexto = ""
    @State private var fechaIngreso = Date()
    @State private var usuario = ""
    @State private var contrasena = ""
    @State private var personaSeleccionada: Persona?

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

                Section("Datos del Empleado") {
                    HStack {
                        TextField("Cargo", text: $cargo)
                        if !cargo.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    HStack {
                        TextField("Departamento", text: $departamento)
                        if !departamento.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    HStack {
                        TextField("Salario", text: $salarioTexto)
                            .keyboardType(.decimalPad)
                        if let salario = Double(salarioTexto), salario > 0 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if !salarioTexto.isEmpty {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                    DatePicker("Fecha de Ingreso", selection: $fechaIngreso, in: ...Date(), displayedComponents: .date)
                }

                Section("Credenciales de Acceso") {
                    HStack {
                        TextField("Usuario", text: $usuario)
                            .autocapitalization(.none)
                            .textContentType(.username)
                        if !usuario.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    HStack {
                        SecureField("Contraseña", text: $contrasena)
                            .textContentType(.newPassword)
                        if contrasena.count >= 6 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if !contrasena.isEmpty {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Nuevo Empleado")
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
                            let salario = Double(salarioTexto) ?? 0
                            await viewModel.crearEmpleado(
                                cargo: cargo,
                                departamento: departamento,
                                salario: salario,
                                fechaIngreso: fechaIngreso,
                                usuario: usuario,
                                contrasena: contrasena,
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
