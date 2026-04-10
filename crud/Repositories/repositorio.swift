//
//  repositorio.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

/// Protocolo que define las operaciones CRUD básicas para el manejo de personas.
/// Actúa como capa de abstracción entre la lógica de negocio y la persistencia de datos.
@MainActor
protocol Repositorio {

    /// Obtiene todas las personas almacenadas.
    /// - Returns: Un arreglo con todas las personas registradas.
    func listarTodos() async throws -> [Persona]

    /// Guarda una nueva persona en el almacenamiento.
    /// - Parameter persona: La persona a guardar.
    func guardar(persona: Persona) async throws

    /// Elimina una persona del almacenamiento por su identificador.
    /// - Parameter id: El UUID de la persona a eliminar.
    func eliminar(id: UUID) async throws
}
