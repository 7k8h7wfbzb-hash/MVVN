//
//  persona.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

/// Modelo de datos que representa a una persona en el sistema.
/// Utiliza SwiftData (`@Model`) para la persistencia automática en base de datos local.
@Model
final class Persona {
    /// Identificador único de la persona.
    var id: UUID
    /// Cédula ecuatoriana de 10 dígitos.
    var cedula: String
    /// Nombre de la persona.
    var nombre: String
    /// Apellido de la persona.
    var apellido: String
    /// Fecha de nacimiento (debe ser anterior a la fecha actual).
    var fechaNacimiento: Date
    /// Género de la persona: "Masculino", "Femenino" u "Otro".
    var genero: String
    /// Correo electrónico de contacto.
    var correo: String
    /// Número de teléfono de contacto.
    var telefono: String
    /// Imagen de perfil almacenada como datos binarios (opcional).
    var imagen: Data?
    /// Relación inversa: cliente asociado a esta persona (opcional).
    @Relationship(inverse: \Cliente.persona) var cliente: Cliente?
    /// Relación inversa: empleado asociado a esta persona (opcional).
    @Relationship(inverse: \Empleado.persona) var empleado: Empleado?

    /// Inicializa una nueva persona con todos sus datos.
    /// - Parameters:
    ///   - id: Identificador único (se genera automáticamente si no se proporciona).
    ///   - cedula: Cédula ecuatoriana de 10 dígitos.
    ///   - nombre: Nombre de la persona.
    ///   - apellido: Apellido de la persona.
    ///   - fechaNacimiento: Fecha de nacimiento.
    ///   - genero: Género de la persona.
    ///   - correo: Correo electrónico.
    ///   - telefono: Número de teléfono.
    ///   - imagen: Datos binarios de la imagen de perfil (opcional).
    init(id: UUID = UUID(), cedula: String, nombre: String, apellido: String, fechaNacimiento: Date, genero: String, correo: String, telefono: String, imagen: Data? = nil) {
        self.id = id
        self.cedula = cedula
        self.nombre = nombre
        self.apellido = apellido
        self.fechaNacimiento = fechaNacimiento
        self.genero = genero
        self.correo = correo
        self.telefono = telefono
        self.imagen = imagen
    }
}
