//
//  empleadoCase.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

enum EmpleadoError: LocalizedError {
    case campoVacio(String)
    case personaNoSeleccionada
    case salarioInvalido

    var errorDescription: String? {
        switch self {
        case .campoVacio(let mensaje): return mensaje
        case .personaNoSeleccionada: return "Debe seleccionar una persona"
        case .salarioInvalido: return "El salario debe ser mayor a 0"
        }
    }
}

@MainActor
struct EmpleadoCase {

    private let repositorio: EmpleadoRepositorio

    init(repositorio: EmpleadoRepositorio) {
        self.repositorio = repositorio
    }

    func crearEmpleado(cargo: String, departamento: String, salario: Double, fechaIngreso: Date, usuario: String, contrasena: String, persona: Persona?) async throws {
        guard let persona else {
            throw EmpleadoError.personaNoSeleccionada
        }
        guard !cargo.isEmpty else {
            throw EmpleadoError.campoVacio("El cargo es obligatorio")
        }
        guard !departamento.isEmpty else {
            throw EmpleadoError.campoVacio("El departamento es obligatorio")
        }
        guard salario > 0 else {
            throw EmpleadoError.salarioInvalido
        }
        guard !usuario.isEmpty else {
            throw EmpleadoError.campoVacio("El usuario es obligatorio")
        }
        guard contrasena.count >= 6 else {
            throw EmpleadoError.campoVacio("La contraseña debe tener al menos 6 caracteres")
        }

        let empleado = Empleado(cargo: cargo, departamento: departamento, salario: salario, fechaIngreso: fechaIngreso, usuario: usuario, contrasena: contrasena, persona: persona)
        try await repositorio.guardar(empleado: empleado)
    }

    func eliminarEmpleado(id: UUID) async throws {
        try await repositorio.eliminar(id: id)
    }
}
