//
//  PersonaListaView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI
import SwiftData

/// Vista principal que muestra la lista de personas registradas.
/// Permite agregar nuevas personas, eliminarlas con swipe, navegar al detalle
/// y cambiar la apariencia de la app (claro/oscuro/sistema).
struct PersonaListaView: View {

    /// Contexto de SwiftData proporcionado por el entorno.
    @Environment(\.modelContext) private var modelContext
    /// Preferencia de apariencia del usuario, sincronizada con `UserDefaults`.
    @AppStorage("apariencia") private var apariencia: Apariencia = .sistema
    /// ViewModel que gestiona el estado y las operaciones de la lista.
    @State private var viewModel: PersonaViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    if viewModel.estaCargando {
                        ProgressView("Cargando...")
                    } else if viewModel.personas.isEmpty {
                        ContentUnavailableView("Sin personas", systemImage: "person.slash", description: Text("Agrega una persona con el boton +"))
                    } else {
                        List {
                            ForEach(viewModel.personas, id: \.id) { persona in
                                NavigationLink(destination: PersonaDetalleView(persona: persona)) {
                                    PersonaRowView(persona: persona)
                                }
                            }
                            .onDelete { indexSet in
                                Task {
                                    for index in indexSet {
                                        let persona = viewModel.personas[index]
                                        await viewModel.eliminarPersona(id: persona.id)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Personas")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Apariencia", selection: $apariencia) {
                            ForEach(Apariencia.allCases, id: \.self) { opcion in
                                Label(opcion.rawValue, systemImage: opcion == .claro ? "sun.max" : opcion == .oscuro ? "moon" : "circle.lefthalf.filled")
                                    .tag(opcion)
                            }
                        }
                    } label: {
                        Image(systemName: apariencia == .claro ? "sun.max" : apariencia == .oscuro ? "moon" : "circle.lefthalf.filled")
                    }
                    .buttonStyle(.glass)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel?.mostrarFormulario = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(.glass)
                }
            }
            .sheet(isPresented: Binding(
                get: { viewModel?.mostrarFormulario ?? false },
                set: { viewModel?.mostrarFormulario = $0 }
            )) {
                if let viewModel {
                    PersonaFormularioView(viewModel: viewModel)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel?.mensajeError != nil },
                set: { if !$0 { viewModel?.mensajeError = nil } }
            )) {
                Button("OK") { viewModel?.mensajeError = nil }
            } message: {
                Text(viewModel?.mensajeError ?? "")
            }
            .task {
                if viewModel == nil {
                    let repositorio = PersonaRepositorio(context: modelContext)
                    viewModel = PersonaViewModel(repositorio: repositorio)
                }
                await viewModel?.cargarPersonas()
            }
        }
    }
}

/// Vista de fila que muestra un resumen de una persona en la lista.
/// Incluye la foto de perfil (o icono por defecto), nombre completo y correo.
struct PersonaRowView: View {

    /// La persona a mostrar en la fila.
    let persona: Persona

    var body: some View {
        HStack(spacing: 12) {
            if let imagenData = persona.imagen, let uiImage = UIImage(data: imagenData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(persona.nombre) \(persona.apellido)")
                    .font(.headline)
                Text(persona.correo)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
