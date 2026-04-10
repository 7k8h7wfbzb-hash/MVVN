//
//  personaRepositorio.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

/// Implementación concreta del protocolo `Repositorio` usando SwiftData.
/// Se encarga de la persistencia de datos de personas mediante `ModelContext`.
class PersonaRepositorio: Repositorio {

    /// Contexto de SwiftData utilizado para las operaciones de persistencia.
    private let context: ModelContext

    /// Inicializa el repositorio con un contexto de SwiftData.
    /// - Parameter context: El `ModelContext` proporcionado por el contenedor de datos.
    init(context: ModelContext) {
        self.context = context
    }

    /// Obtiene todas las personas almacenadas en la base de datos.
    /// - Returns: Un arreglo con todas las personas registradas.
    func listarTodos() async throws -> [Persona] {
        let descriptor = FetchDescriptor<Persona>()
        return try context.fetch(descriptor)
    }

    /// Inserta una nueva persona en la base de datos y guarda los cambios.
    /// - Parameter persona: La persona a guardar.
    func guardar(persona: Persona) async throws {
        context.insert(persona)
        try context.save()
    }

    /// Busca y elimina una persona de la base de datos por su identificador.
    /// - Parameter id: El UUID de la persona a eliminar.
    func eliminar(id: UUID) async throws {
        let descriptor = FetchDescriptor<Persona>(predicate: #Predicate { $0.id == id })
        if let persona = try context.fetch(descriptor).first {
            context.delete(persona)
            try context.save()
        }
    }
}
