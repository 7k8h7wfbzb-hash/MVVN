//
//  empleadoRepositorio.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

@MainActor
class EmpleadoRepositorio {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func listarTodos() async throws -> [Empleado] {
        let descriptor = FetchDescriptor<Empleado>()
        return try context.fetch(descriptor)
    }

    func guardar(empleado: Empleado) async throws {
        context.insert(empleado)
        try context.save()
    }

    func eliminar(id: UUID) async throws {
        let descriptor = FetchDescriptor<Empleado>(predicate: #Predicate { $0.id == id })
        if let empleado = try context.fetch(descriptor).first {
            context.delete(empleado)
            try context.save()
        }
    }

    func listarPersonasSinEmpleado() async throws -> [Persona] {
        let descriptor = FetchDescriptor<Persona>(predicate: #Predicate { $0.empleado == nil })
        return try context.fetch(descriptor)
    }
}
