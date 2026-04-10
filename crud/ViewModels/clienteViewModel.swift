//
//  clienteViewModel.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

@MainActor
@Observable
final class ClienteViewModel {

    var clientes: [Cliente] = []
    var personasDisponibles: [Persona] = []
    var estaCargando: Bool = false
    var mensajeError: String?
    var mostrarFormulario: Bool = false

    private let clienteCase: ClienteCase
    private let repositorio: ClienteRepositorio

    init(repositorio: ClienteRepositorio) {
        self.repositorio = repositorio
        self.clienteCase = ClienteCase(repositorio: repositorio)
    }

    func cargarClientes() async {
        estaCargando = true
        do {
            clientes = try await repositorio.listarTodos()
            personasDisponibles = try await repositorio.listarPersonasSinCliente()
        } catch {
            mensajeError = error.localizedDescription
        }
        estaCargando = false
    }

    func crearCliente(direccion: String, tipoCliente: String, persona: Persona?) async {
        do {
            try await clienteCase.crearCliente(direccion: direccion, tipoCliente: tipoCliente, persona: persona)
            await cargarClientes()
        } catch {
            mensajeError = error.localizedDescription
        }
    }

    func eliminarCliente(id: UUID) async {
        do {
            try await clienteCase.eliminarCliente(id: id)
            await cargarClientes()
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}
