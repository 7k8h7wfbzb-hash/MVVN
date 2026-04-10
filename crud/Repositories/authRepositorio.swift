//
//  authRepositorio.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

@MainActor
class AuthRepositorio {

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func buscarPorCredenciales(usuario: String, contrasena: String) async throws -> Empleado? {
        let descriptor = FetchDescriptor<Empleado>(
            predicate: #Predicate { $0.usuario == usuario && $0.contrasena == contrasena }
        )
        return try context.fetch(descriptor).first
    }

    func existeUsuario(usuarioBuscado: String) async throws -> Bool {
        let descriptor = FetchDescriptor<Empleado>(
            predicate: #Predicate { $0.usuario == usuarioBuscado }
        )
        return try !context.fetch(descriptor).isEmpty
    }

    func guardarRegistro(persona: Persona, empleado: Empleado) async throws {
        context.insert(persona)
        context.insert(empleado)
        try context.save()
    }
}
