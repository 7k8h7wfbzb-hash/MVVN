//
//  empleado.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

/// Modelo de datos que representa a un empleado en el sistema.
/// Tiene una relación con `Persona` para heredar los datos personales base.
@Model
final class Empleado {
    var id: UUID
    /// Cargo o puesto del empleado.
    var cargo: String
    /// Departamento al que pertenece.
    var departamento: String
    /// Salario del empleado.
    var salario: Double
    /// Fecha de ingreso a la empresa.
    var fechaIngreso: Date
    /// Nombre de usuario para el login.
    var usuario: String
    /// Contraseña del empleado.
    var contrasena: String
    /// Relación con la persona que contiene los datos base.
    var persona: Persona?

    init(id: UUID = UUID(), cargo: String, departamento: String, salario: Double, fechaIngreso: Date, usuario: String, contrasena: String, persona: Persona? = nil) {
        self.id = id
        self.cargo = cargo
        self.departamento = departamento
        self.salario = salario
        self.fechaIngreso = fechaIngreso
        self.usuario = usuario
        self.contrasena = contrasena
        self.persona = persona
    }
}
