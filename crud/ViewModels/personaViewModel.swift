//
//  personaViewModel.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import Foundation

/// ViewModel que gestiona el estado de la interfaz de usuario para la lista de personas.
/// Utiliza `@Observable` para notificar cambios a las vistas de SwiftUI automáticamente.
/// Se ejecuta en el hilo principal (`@MainActor`) para garantizar actualizaciones seguras de la UI.
@MainActor
@Observable
final class PersonaViewModel {

    /// Lista de personas cargadas desde el repositorio.
    var personas: [Persona] = []
    /// Indica si se están cargando datos (para mostrar indicador de progreso).
    var estaCargando: Bool = false
    /// Mensaje de error actual para mostrar al usuario (nil si no hay error).
    var mensajeError: String?
    /// Controla la presentación del formulario de creación de persona.
    var mostrarFormulario: Bool = false

    /// Caso de uso que contiene la lógica de negocio y validaciones.
    private let personaCase: PersonaCase
    /// Repositorio para acceso directo a datos (lectura).
    private let repository: PersonaRepositorio

    /// Inicializa el ViewModel con un repositorio de personas.
    /// - Parameter repositorio: El repositorio utilizado para la persistencia de datos.
    init(repositorio: PersonaRepositorio) {
        self.repository = repositorio
        self.personaCase = PersonaCase(repositorio: repository)
    }

    /// Carga todas las personas desde el repositorio y actualiza la lista.
    /// Muestra un indicador de carga durante la operación.
    func cargarPersonas() async {
        estaCargando = true
        do {
            personas = try await repository.listarTodos()
        } catch {
            mensajeError = error.localizedDescription
        }
        estaCargando = false
    }

    /// Crea una nueva persona validando los datos a través del caso de uso.
    /// Si la creación es exitosa, recarga la lista de personas.
    /// Si falla, almacena el mensaje de error para mostrarlo en la UI.
    /// - Parameters:
    ///   - cedula: Cédula ecuatoriana de 10 dígitos.
    ///   - nombre: Nombre de la persona.
    ///   - apellido: Apellido de la persona.
    ///   - fechaNacimiento: Fecha de nacimiento.
    ///   - genero: Género de la persona.
    ///   - correo: Correo electrónico.
    ///   - telefono: Número de teléfono.
    ///   - imagen: Datos binarios de la imagen de perfil (opcional).
    func crearPersona(cedula: String, nombre: String, apellido: String, fechaNacimiento: Date, genero: String, correo: String, telefono: String, imagen: Data?) async {
        do {
            try await personaCase.crearPersona(cedula: cedula, nombre: nombre, apellido: apellido, fechaNacimiento: fechaNacimiento, genero: genero, correo: correo, telefono: telefono, imagen: imagen)
            await cargarPersonas()
        } catch {
            mensajeError = error.localizedDescription
        }
    }

    /// Elimina una persona por su identificador y recarga la lista.
    /// - Parameter id: El UUID de la persona a eliminar.
    func eliminarPersona(id: UUID) async {
        do {
            try await personaCase.eliminarPersona(id: id)
            await cargarPersonas()
        } catch {
            mensajeError = error.localizedDescription
        }
    }
}
