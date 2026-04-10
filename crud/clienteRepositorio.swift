//
//  clienteRepositorio.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

@MainActor
class ClienteRepositorio {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func listarTodos() async throws -> [Cliente] {
        let descriptor = FetchDescriptor<Cliente>()
        return try context.fetch(descriptor)
    }

    func guardar(cliente: Cliente) async throws {
        context.insert(cliente)
        try context.save()
    }

    func eliminar(id: UUID) async throws {
        let descriptor = FetchDescriptor<Cliente>(predicate: #Predicate { $0.id == id })
        if let cliente = try context.fetch(descriptor).first {
            context.delete(cliente)
            try context.save()
        }
    }

    func listarPersonasSinCliente() async throws -> [Persona] {
        let descriptor = FetchDescriptor<Persona>(predicate: #Predicate { $0.cliente == nil })
        return try context.fetch(descriptor)
    }
}
