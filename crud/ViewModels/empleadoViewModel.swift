//
//  empleadoViewModel.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

@MainActor
@Observable
final class EmpleadoViewModel {

    var empleados: [Empleado] = []
    var personasDisponibles: [Persona] = []
    var estaCargando: Bool = false
    var mensajeError: String?
    var mostrarFormulario: Bool = false

    private let empleadoCase: EmpleadoCase
    private let repositorio: EmpleadoRepositorio

    init(repositorio: EmpleadoRepositorio) {
        self.repositorio = repositorio
        self.empleadoCase = EmpleadoCase(repositorio: repositorio)
    }

    func cargarEmpleados() async {
        estaCargando = true
        do {
            empleados = try await repositorio.listarTodos()
            personasDisponibles = try await repositorio.listarPersonasSinEmpleado()
        } catch {
            mensajeError = error.localizedDescription
        }
        estaCargando = false
    }

    func crearEmpleado(cargo: String, departamento: String, salario: Double, fechaIngreso: Date, usuario: String, contrasena: String, persona: Persona?) async {
        do {
            try await empleadoCase.crearEmpleado(cargo: cargo, departamento: departamento, salario: salario, fechaIngreso: fechaIngreso, usuario: usuario, contrasena: contrasena, persona: persona)
            await cargarEmpleados()
        } catch {
            mensajeError = error.localizedDescription
        }
    }

    func eliminarEmpleado(id: UUID) async {
        do {
            try await empleadoCase.eliminarEmpleado(id: id)
            await cargarEmpleados()
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}
