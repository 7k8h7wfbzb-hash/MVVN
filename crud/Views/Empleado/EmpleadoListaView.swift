//
//  EmpleadoListaView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI
import SwiftData

struct EmpleadoListaView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: EmpleadoViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    if viewModel.estaCargando {
                        ProgressView("Cargando...")
                    } else if viewModel.empleados.isEmpty {
                        ContentUnavailableView("Sin empleados", systemImage: "person.2.slash", description: Text("Agrega un empleado con el botón +"))
                    } else {
                        List {
                            ForEach(viewModel.empleados, id: \.id) { empleado in
                                NavigationLink(destination: EmpleadoDetalleView(empleado: empleado)) {
                                    EmpleadoRowView(empleado: empleado)
                                }
                            }
                            .onDelete { indexSet in
                                Task {
                                    for index in indexSet {
                                        let empleado = viewModel.empleados[index]
                                        await viewModel.eliminarEmpleado(id: empleado.id)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Empleados")
            .toolbar {
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
                    EmpleadoFormularioView(viewModel: viewModel)
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
                    let repositorio = EmpleadoRepositorio(context: modelContext)
                    viewModel = EmpleadoViewModel(repositorio: repositorio)
                }
                await viewModel?.cargarEmpleados()
            }
        }
    }
}

struct EmpleadoRowView: View {

    let empleado: Empleado

    var body: some View {
        HStack(spacing: 12) {
            if let persona = empleado.persona, let imagenData = persona.imagen, let uiImage = UIImage(data: imagenData) {
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
                if let persona = empleado.persona {
                    Text("\(persona.nombre) \(persona.apellido)")
                        .font(.headline)
                }
                Text("\(empleado.cargo) - \(empleado.departamento)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
