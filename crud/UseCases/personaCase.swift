//
//  personaCase.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

/// Enumeración de errores de validación para los datos de una persona.
/// Conforma `LocalizedError` para proporcionar mensajes descriptivos al usuario.
enum PersonaError: LocalizedError {
    /// Un campo obligatorio está vacío, con el mensaje específico del campo.
    case campoVacio(String)
    /// El formato del correo electrónico no es válido.
    case correoInvalido
    /// La fecha de nacimiento es futura (no permitida).
    case fechaInvalida
    /// La cédula ecuatoriana no cumple con el algoritmo de validación.
    case cedulaInvalida

    var errorDescription: String? {
        switch self {
        case .campoVacio(let mensaje): return mensaje
        case .correoInvalido: return "El correo no es válido"
        case .fechaInvalida: return "La fecha de nacimiento no puede ser futura"
        case .cedulaInvalida: return "La cédula no es válida"
        }
    }
}

/// Caso de uso que contiene la lógica de negocio para la gestión de personas.
/// Valida los datos antes de delegarlos al repositorio para su persistencia.
@MainActor
struct PersonaCase {

    /// Repositorio utilizado para las operaciones de persistencia.
    private let repositorio: PersonaRepositorio

    /// Inicializa el caso de uso con un repositorio.
    /// - Parameter repositorio: El repositorio de personas para la persistencia de datos.
    init(repositorio: PersonaRepositorio) {
        self.repositorio = repositorio
    }

    /// Valida y crea una nueva persona en el sistema.
    /// Realiza las siguientes validaciones antes de guardar:
    /// - Campos obligatorios no vacíos (cédula, nombre, apellido, correo, teléfono).
    /// - Cédula ecuatoriana válida (algoritmo módulo 10).
    /// - Formato de correo electrónico válido.
    /// - Fecha de nacimiento no futura.
    /// - Parameters:
    ///   - cedula: Cédula ecuatoriana de 10 dígitos.
    ///   - nombre: Nombre de la persona.
    ///   - apellido: Apellido de la persona.
    ///   - fechaNacimiento: Fecha de nacimiento.
    ///   - genero: Género de la persona.
    ///   - correo: Correo electrónico.
    ///   - telefono: Número de teléfono.
    ///   - imagen: Datos binarios de la imagen de perfil (opcional).
    /// - Throws: `PersonaError` si alguna validación falla.
    func crearPersona(cedula: String, nombre: String, apellido: String, fechaNacimiento: Date, genero: String, correo: String, telefono: String, imagen: Data?) async throws {
        guard !cedula.isEmpty else {
            throw PersonaError.campoVacio("La cédula es obligatoria")
        }
        guard PersonaCase.esCedulaValida(cedula) else {
            throw PersonaError.cedulaInvalida
        }
        guard !nombre.isEmpty else {
            throw PersonaError.campoVacio("El nombre es obligatorio")
        }
        guard !apellido.isEmpty else {
            throw PersonaError.campoVacio("El apellido es obligatorio")
        }
        guard !correo.isEmpty else {
            throw PersonaError.campoVacio("El correo es obligatorio")
        }
        guard PersonaCase.esCorreoValido(correo) else {
            throw PersonaError.correoInvalido
        }
        guard !telefono.isEmpty else {
            throw PersonaError.campoVacio("El teléfono es obligatorio")
        }
        guard fechaNacimiento < Date() else {
            throw PersonaError.fechaInvalida
        }

        let persona = Persona(cedula: cedula, nombre: nombre, apellido: apellido, fechaNacimiento: fechaNacimiento, genero: genero, correo: correo, telefono: telefono, imagen: imagen)
        try await repositorio.guardar(persona: persona)
    }

    /// Valida si un correo electrónico tiene un formato válido usando expresión regular.
    /// Verifica que tenga: parte local + "@" + dominio + "." + extensión (mínimo 2 caracteres).
    /// - Parameter correo: El correo electrónico a validar.
    /// - Returns: `true` si el correo tiene un formato válido, `false` en caso contrario.
    static func esCorreoValido(_ correo: String) -> Bool {
        let patron = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return correo.range(of: patron, options: .regularExpression) != nil
    }

    /// Valida si una cédula ecuatoriana es válida usando el algoritmo módulo 10.
    /// Verificaciones:
    /// 1. Exactamente 10 dígitos numéricos.
    /// 2. Código de provincia válido (01-24).
    /// 3. Tercer dígito menor a 6.
    /// 4. Dígito verificador correcto (posiciones impares × 2, si ≥ 10 se resta 9, suma total módulo 10).
    /// - Parameter cedula: La cédula a validar.
    /// - Returns: `true` si la cédula es válida, `false` en caso contrario.
    static func esCedulaValida(_ cedula: String) -> Bool {
        guard cedula.count == 10, cedula.allSatisfy(\.isNumber) else {
            return false
        }

        let digitos = cedula.compactMap { $0.wholeNumberValue }

        let provincia = digitos[0] * 10 + digitos[1]
        guard provincia >= 1, provincia <= 24 else {
            return false
        }

        guard digitos[2] < 6 else {
            return false
        }

        var suma = 0
        for i in 0..<9 {
            var valor = digitos[i]
            if i % 2 == 0 {
                valor *= 2
                if valor >= 10 { valor -= 9 }
            }
            suma += valor
        }

        let digitoVerificador = (10 - (suma % 10)) % 10
        return digitoVerificador == digitos[9]
    }

    /// Elimina una persona del sistema por su identificador.
    /// - Parameter id: El UUID de la persona a eliminar.
    /// - Throws: Error si la eliminación falla en el repositorio.
    func eliminarPersona(id: UUID) async throws {
        try await repositorio.eliminar(id: id)
    }
}
