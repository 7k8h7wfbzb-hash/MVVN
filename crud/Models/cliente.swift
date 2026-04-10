//
//  cliente.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

/// Modelo de datos que representa a un cliente en el sistema.
/// Tiene una relación con `Persona` para heredar los datos personales base.
@Model
final class Cliente {
    var id: UUID
    /// Dirección del cliente.
    var direccion: String
    /// Tipo de cliente: "Regular", "VIP" o "Corporativo".
    var tipoCliente: String
    /// Relación con la persona que contiene los datos base.
    var persona: Persona?

    init(id: UUID = UUID(), direccion: String, tipoCliente: String, persona: Persona? = nil) {
        self.id = id
        self.direccion = direccion
        self.tipoCliente = tipoCliente
        self.persona = persona
    }
}
