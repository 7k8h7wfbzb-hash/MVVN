//
//  LoginView.swift
//  crud
//
//  Created by Kleber Oswaldo Muy Landi on 9/4/26.
//

import SwiftUI

struct LoginView: View {

    var authViewModel: AuthViewModel

    @State private var usuario = ""
    @State private var contrasena = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()

                Image(systemName: "person.badge.shield.checkmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.tint)

                Text("Iniciar Sesión")
                    .font(.largeTitle)
                    .bold()

                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundStyle(.secondary)
                        TextField("Usuario", text: $usuario)
                            .autocapitalization(.none)
                            .textContentType(.username)
                    }
                    .padding()
                    .glassEffect(in: .rect(cornerRadius: 12))

                    HStack {
                        Image(systemName: "lock")
                            .foregroundStyle(.secondary)
                        SecureField("Contraseña", text: $contrasena)
                            .textContentType(.password)
                    }
                    .padding()
                    .glassEffect(in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal)

                Button {
                    Task {
                        await authViewModel.iniciarSesion(usuario: usuario, contrasena: contrasena)
                    }
                } label: {
                    if authViewModel.estaCargando {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Ingresar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .disabled(usuario.isEmpty || contrasena.isEmpty || authViewModel.estaCargando)

                Spacer()
                Spacer()
            }
            .alert("Error", isPresented: Binding(
                get: { authViewModel.mensajeError != nil },
                set: { if !$0 { authViewModel.mensajeError = nil } }
            )) {
                Button("OK") { authViewModel.mensajeError = nil }
            } message: {
                Text(authViewModel.mensajeError ?? "")
            }
        }
    }
}
