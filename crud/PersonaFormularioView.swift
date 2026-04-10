//
//  PersonaFormularioView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI
import PhotosUI

struct PersonaFormularioView: View {

    @Environment(\.dismiss) private var dismiss
    var viewModel: PersonaViewModel

    @State private var cedula = ""
    @State private var nombre = ""
    @State private var apellido = ""
    @State private var fechaNacimiento = Date()
    @State private var genero = "Masculino"
    @State private var correo = ""
    @State private var telefono = ""
    @State private var imagenSeleccionada: PhotosPickerItem?
    @State private var imagenData: Data?

    private let generos = ["Masculino", "Femenino", "Otro"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos Personales") {
                    TextField("Cedula", text: $cedula)
                        .keyboardType(.numberPad)
                    TextField("Nombre", text: $nombre)
                    TextField("Apellido", text: $apellido)
                    DatePicker("Fecha de Nacimiento", selection: $fechaNacimiento, in: ...Date(), displayedComponents: .date)
                    Picker("Genero", selection: $genero) {
                        ForEach(generos, id: \.self) { g in
                            Text(g)
                        }
                    }
                }

                Section("Contacto") {
                    TextField("Correo", text: $correo)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Telefono", text: $telefono)
                        .keyboardType(.phonePad)
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
