//
//  ClienteListaView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI
import SwiftData

struct ClienteListaView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ClienteViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    if viewModel.estaCargando {
                        ProgressView("Cargando...")
                    } else if viewModel.clientes.isEmpty {
                        ContentUnavailableView("Sin clientes", systemImage: "person.2.slash", description: Text("Agrega un cliente con el botón +"))
                    } else {
                        List {
                            ForEach(viewModel.clientes, id: \.id) { cliente in
                                NavigationLink(destination: ClienteDetalleView(cliente: cliente)) {
                                    ClienteRowView(cliente: cliente)
                                }
                            }
                            .onDelete { indexSet in
                                Task {
                                    for index in indexSet {
                                        let cliente = viewModel.clientes[index]
                                        await viewModel.eliminarCliente(id: cliente.id)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Clientes")
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
                    ClienteFormularioView(viewModel: viewModel)
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
                    let repositorio = ClienteRepositorio(context: modelContext)
                    viewModel = ClienteViewModel(repositorio: repositorio)
                }
                await viewModel?.cargarClientes()
            }
        }
    }
}

struct ClienteRowView: View {

    let cliente: Cliente

    var body: some View {
        HStack(spacing: 12) {
            if let persona = cliente.persona, let imagenData = persona.imagen, let uiImage = UIImage(data: imagenData) {
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
                if let persona = cliente.persona {
                    Text("\(persona.nombre) \(persona.apellido)")
                        .font(.headline)
                }
                Text(cliente.tipoCliente)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
