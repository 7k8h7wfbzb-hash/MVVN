//
//  crudApp.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI
import SwiftData

/// Enumeración que define las opciones de apariencia de la aplicación.
/// Se persiste con `@AppStorage` para mantener la preferencia del usuario entre sesiones.
enum Apariencia: String, CaseIterable {
    /// Sigue la configuración del sistema operativo.
    case sistema = "Sistema"
    /// Fuerza el modo claro.
    case claro = "Claro"
    /// Fuerza el modo oscuro.
    case oscuro = "Oscuro"

    /// Convierte la opción de apariencia a un `ColorScheme` de SwiftUI.
    /// Retorna `nil` para el modo sistema, dejando que iOS decida.
    var colorScheme: ColorScheme? {
        switch self {
        case .sistema: return nil
        case .claro: return .light
        case .oscuro: return .dark
        }
    }
}

/// Punto de entrada principal de la aplicación CRUD de personas.
/// Configura el contenedor de SwiftData para la persistencia y aplica la apariencia seleccionada.
@main
struct crudApp: App {
    @AppStorage("apariencia") private var apariencia: Apariencia = .sistema

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Persona.self,
            Cliente.self,
            Empleado.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(apariencia.colorScheme)
        }
        .modelContainer(sharedModelContainer)
    }
}

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @AppStorage("apariencia") private var apariencia: Apariencia = .sistema
    @State private var authViewModel: AuthViewModel?

    var body: some View {
        Group {
            if let authViewModel {
                if authViewModel.estaAutenticado {
                    TabView {
                        Tab("Personas", systemImage: "person.3") {
                            PersonaListaView()
                        }
                        Tab("Clientes", systemImage: "person.crop.rectangle.stack") {
                            ClienteListaView()
                        }
                        Tab("Empleados", systemImage: "briefcase") {
                            EmpleadoListaView()
                        }
                        Tab("Perfil", systemImage: "person.circle") {
                            PerfilView(authViewModel: authViewModel)
                        }
                    }
                } else {
                    LoginView(authViewModel: authViewModel)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            if authViewModel == nil {
                authViewModel = AuthViewModel(repositorio: AuthRepositorio(context: modelContext))
            }
        }
    }
}
