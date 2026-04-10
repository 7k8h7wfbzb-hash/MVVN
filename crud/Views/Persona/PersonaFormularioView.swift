//
//  PersonaFormularioView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI
import PhotosUI

/// Vista de formulario para registrar una nueva persona.
/// Incluye validación en tiempo real con indicadores visuales (check verde / X roja)
/// para cédula y correo electrónico. Permite seleccionar una foto de perfil desde la galería.
struct PersonaFormularioView: View {

    /// Acción para cerrar el formulario.
    @Environment(\.dismiss) private var dismiss
    /// ViewModel compartido para ejecutar la creación de la persona.
    var viewModel: PersonaViewModel

    // MARK: - Estado del formulario
    @State private var cedula = ""
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var fechaNacimiento = Date()
    @State private var genero = "Masculino"
    @State private var correo = ""
    @State private var telefono = ""
    @State private var imagenSeleccionada: PhotosPickerItem?
    @State private var imagenData: Data?

    /// Opciones disponibles para el selector de género.
    private let generos = ["Masculino", "Femenino", "Otro"]

    /// Indica si la cédula ingresada es válida según el algoritmo ecuatoriano.
    private var esCedulaValida: Bool {
        PersonaCase.esCedulaValida(cedula)
    }

    /// Indica si el correo ingresado tiene un formato válido.
    private var esCorreoValido: Bool {
        PersonaCase.esCorreoValido(correo)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos Personales") {
                    HStack {
                        TextField("Cedula", text: $cedula)
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
                    Picker("Genero", selection: $genero) {
                        ForEach(generos, id: \.self) { g in
                            Text(g)
                        }
                    }
                }

                Section("Contacto") {
                    HStack {
                        TextField("Correo", text: $correo)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                        if !correo.isEmpty {
                            Image(systemName: esCorreoValido ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(esCorreoValido ? .green : .red)
                        }
                    }
                    HStack {
                        TextField("Telefono", text: $telefono)
                            .keyboardType(.phonePad)
                        if !telefono.isEmpty {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                    }
                }

                Section("Foto") {
                    PhotosPicker(selection: $imagenSeleccionada, matching: .images) {
                        if let imagenData, let uiImage = UIImage(data: imagenData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Label("Seleccionar foto", systemImage: "photo")
                        }
                    }
                }
            }
            .navigationTitle("Nueva Persona")
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
                            await viewModel.crearPersona(
                                cedula: cedula,
                                nombre: nombre,
                                apellido: apellido,
                                fechaNacimiento: fechaNacimiento,
                                genero: genero,
                                correo: correo,
                                telefono: telefono,
                                imagen: imagenData
                            )
                            if viewModel.mensajeError == nil {
                                dismiss()
                            }
                        }
                    }
                    .buttonStyle(.glass)
                }
            }
            .onChange(of: imagenSeleccionada) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        imagenData = data
                    }
                }
            }
        }
    }
}
