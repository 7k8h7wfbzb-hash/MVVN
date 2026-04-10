//
//  authCase.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

enum AuthError: LocalizedError {
    case credencialesInvalidas
    case usuarioExistente
    case campoVacio(String)
    case cedulaInvalida
    case correoInvalido
    case contrasenaCorta

    var errorDescription: String? {
        switch self {
        case .credencialesInvalidas: return "Usuario o contraseña incorrectos"
        case .usuarioExistente: return "El usuario ya existe"
        case .campoVacio(let mensaje): return mensaje
        case .cedulaInvalida: return "La cédula no es válida"
        case .correoInvalido: return "El correo no es válido"
        case .contrasenaCorta: return "La contraseña debe tener al menos 6 caracteres"
        }
    }
}

@MainActor
struct AuthCase {

    private let repositorio: AuthRepositorio

    init(repositorio: AuthRepositorio) {
        self.repositorio = repositorio
    }

    func iniciarSesion(usuario: String, contrasena: String) async throws -> Empleado {
        guard let empleado = try await repositorio.buscarPorCredenciales(usuario: usuario, contrasena: contrasena) else {
            throw AuthError.credencialesInvalidas
        }
        return empleado
    }

    func registrar(cedula: String, nombre: String, apellido: String, fechaNacimiento: Date, genero: String, correo: String, telefono: String, cargo: String, departamento: String, salario: Double, usuario: String, contrasena: String) async throws -> Empleado {
        // Validar que el usuario no exista
        guard try await !repositorio.existeUsuario(usuarioBuscado: usuario) else {
            throw AuthError.usuarioExistente
        }

        // Validar campos obligatorios
        guard !cedula.isEmpty else { throw AuthError.campoVacio("La cédula es obligatoria") }
        guard !nombre.isEmpty else { throw AuthError.campoVacio("El nombre es obligatorio") }
        guard !apellido.isEmpty else { throw AuthError.campoVacio("El apellido es obligatorio") }
        guard !correo.isEmpty else { throw AuthError.campoVacio("El correo es obligatorio") }
        guard !telefono.isEmpty else { throw AuthError.campoVacio("El teléfono es obligatorio") }
        guard !cargo.isEmpty else { throw AuthError.campoVacio("El cargo es obligatorio") }
        guard !departamento.isEmpty else { throw AuthError.campoVacio("El departamento es obligatorio") }
        guard !usuario.isEmpty else { throw AuthError.campoVacio("El usuario es obligatorio") }

        // Validaciones de formato
        guard PersonaCase.esCedulaValida(cedula) else { throw AuthError.cedulaInvalida }
        guard PersonaCase.esCorreoValido(correo) else { throw AuthError.correoInvalido }
        guard contrasena.count >= 6 else { throw AuthError.contrasenaCorta }

        // Crear persona y empleado
        let persona = Persona(cedula: cedula, nombre: nombre, apellido: apellido, fechaNacimiento: fechaNacimiento, genero: genero, correo: correo, telefono: telefono)
        let empleado = Empleado(cargo: cargo, departamento: departamento, salario: salario, fechaIngreso: Date(), usuario: usuario, contrasena: contrasena, persona: persona)

        try await repositorio.guardarRegistro(persona: persona, empleado: empleado)

        return empleado
    }
}
