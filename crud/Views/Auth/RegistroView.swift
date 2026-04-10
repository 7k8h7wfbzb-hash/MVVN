//
//  RegistroView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct RegistroView: View {

    @Environment(\.dismiss) private var dismiss
    var authViewModel: AuthViewModel

    // Datos personales
    @State private var cedula = ""
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var fechaNacimiento = Date()
    @State private var genero = "Masculino"
    @State private var correo = ""
    @State private var telefono = ""

    // Datos de empleado
    @State private var cargo = ""
    @State private var departamento = ""
    @State private var salarioTexto = ""

    // Credenciales
    @State private var usuario = ""
    @State private var contrasena = ""
    @State private var confirmarContrasena = ""

    private let generos = ["Masculino", "Femenino", "Otro"]

    private var esCedulaValida: Bool {
        PersonaCase.esCedulaValida(cedula)
    }

    private var esCorreoValido: Bool {
        PersonaCase.esCorreoValido(correo)
    }

    private var contrasenaCoincide: Bool {
        !contrasena.isEmpty && contrasena == confirmarContrasena
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos Personales") {
                    HStack {
                        TextField("Cédula", text: $cedula)
                            .keyboardType(.numberPad)
                        if !cedula.isEmpty {
                            Image(systemName: esCedulaValida ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(esCedulaValida ? .green : .red)
                        }
                    }
                    HStack {
                        TextField("Nombre", text: $nombre)
                        if !nombre.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    HStack {
                        TextField("Apellido", text: $apellido)
                        if !apellido.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                    DatePicker("Fecha de Nacimiento", selection: $fechaNacimiento, in: ...Date(), displayedComponents: .date)
                    Picker("Género", selection: $genero) {
                        ForEach(generos, id: \.self) { g in
                            Text(g)
                        }
                    }
                }

                Section("Contacto") {
                    HStack {
                        TextField("Correo", text: $correo)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        if !correo.isEmpty {
                            Image(systemName: esCorreoValido ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(esCorreoValido ? .green : .red)
                        }
                    }
                    HStack {
                        TextField("Teléfono", text: $telefono)
                            .keyboardType(.phonePad)
                        if !telefono.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }

                Section("Datos de Empleado") {
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
                    HStack {
                        SecureField("Confirmar Contraseña", text: $confirmarContrasena)
                        if contrasenaCoincide {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        } else if !confirmarContrasena.isEmpty {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Registro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .buttonStyle(.glass)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Registrar") {
                        Task {
                            let salario = Double(salarioTexto) ?? 0
                            await authViewModel.registrar(
                                cedula: cedula,
                                nombre: nombre,
                                apellido: apellido,
                                fechaNacimiento: fechaNacimiento,
                                genero: genero,
                                correo: correo,
                                telefono: telefono,
                                cargo: cargo,
                                departamento: departamento,
                                salario: salario,
                                usuario: usuario,
                                contrasena: contrasena
                            )
                            if authViewModel.estaAutenticado {
                                dismiss()
                            }
                        }
                    }
                    .buttonStyle(.glass)
                    .disabled(!contrasenaCoincide)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { authViewModel.mensajeError != nil },
                set: { if !$0 { authViewModel.mensajeError = nil } }
            )) {
                Button("OK") { authViewModel.mensajeError = nil }
            } message: {
                Text(authViewModel.mensajeError ?? "")
            }
        }
    }
}
