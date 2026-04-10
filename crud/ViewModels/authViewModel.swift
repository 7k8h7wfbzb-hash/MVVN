//
//  authViewModel.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation
import SwiftData

@MainActor
@Observable
final class AuthViewModel {

    var estaAutenticado: Bool = false
    var empleadoActual: Empleado?
    var mensajeError: String?
    var estaCargando: Bool = false

    private let authCase: AuthCase

    init(repositorio: AuthRepositorio) {
        self.authCase = AuthCase(repositorio: repositorio)
    }

    func iniciarSesion(usuario: String, contrasena: String) async {
        estaCargando = true
        mensajeError = nil

        do {
            empleadoActual = try await authCase.iniciarSesion(usuario: usuario, contrasena: contrasena)
            estaAutenticado = true
        } catch {
            mensajeError = error.localizedDescription
        }

        estaCargando = false
    }

    func registrar(cedula: String, nombre: String, apellido: String, fechaNacimiento: Date, genero: String, correo: String, telefono: String, cargo: String, departamento: String, salario: Double, usuario: String, contrasena: String) async {
        estaCargando = true
        mensajeError = nil

        do {
            empleadoActual = try await authCase.registrar(cedula: cedula, nombre: nombre, apellido: apellido, fechaNacimiento: fechaNacimiento, genero: genero, correo: correo, telefono: telefono, cargo: cargo, departamento: departamento, salario: salario, usuario: usuario, contrasena: contrasena)
            estaAutenticado = true
        } catch {
            mensajeError = error.localizedDescription
        }

        estaCargando = false
    }

    func cerrarSesion() {
        estaAutenticado = false
        empleadoActual = nil
    }
}
