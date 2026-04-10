//
//  clienteCase.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

enum ClienteError: LocalizedError {
    case campoVacio(String)
    case personaNoSeleccionada

    var errorDescription: String? {
        switch self {
        case .campoVacio(let mensaje): return mensaje
        case .personaNoSeleccionada: return "Debe seleccionar una persona"
        }
    }
}

@MainActor
struct ClienteCase {

    private let repositorio: ClienteRepositorio

    init(repositorio: ClienteRepositorio) {
        self.repositorio = repositorio
    }

    func crearCliente(direccion: String, tipoCliente: String, persona: Persona?) async throws {
        guard let persona else {
            throw ClienteError.personaNoSeleccionada
        }
        guard !direccion.isEmpty else {
            throw ClienteError.campoVacio("La dirección es obligatoria")
        }
        guard !tipoCliente.isEmpty else {
            throw ClienteError.campoVacio("El tipo de cliente es obligatorio")
        }

        let cliente = Cliente(direccion: direccion, tipoCliente: tipoCliente, persona: persona)
        try await repositorio.guardar(cliente: cliente)
    }

    func eliminarCliente(id: UUID) async throws {
        try await repositorio.eliminar(id: id)
    }
}
