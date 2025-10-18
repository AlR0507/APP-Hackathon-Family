//
//  Profile.swift
//  Family+
//
//  Created by CETYS Universidad  on 09/10/25.
//

import SwiftUI
import MapKit

struct Profile: View {
    var body: some View {
        ProfileView()
    }
}

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var showEdit = false
    @State private var showSettings = false
    @State private var selectedTab = 0
    @State private var navigateToHome = false

    var body: some View {
        ZStack {
            // Fondo sutil con degradado
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.30, blue: 0.60),
                         Color(red: 0.15, green: 0.35, blue: 0.65)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // HEADER con botón regresar
                ZStack {
                    LinearGradient(
                        colors: [Color(red: 1.0, green: 0.70, blue: 0.10),
                                 Color(red: 1.0, green: 0.62, blue: 0.00)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .frame(height: 96)
                    .overlay(
                        HStack {
                            Button {
                                // Vuelve a Home (cuadra con cómo navegas desde Home)
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.2))
                                    .clipShape(Circle())
                            }
                            Spacer()
                            Text("Mi Perfil")
                                .font(.system(size: 20, weight: .heavy))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 6)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {

                        // Tarjeta principal del usuario (hero)
                        ZStack(alignment: .topTrailing) {
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.12), radius: 10, y: 4)

                            VStack(spacing: 12) {
                                // Avatar
                                ZStack {
                                    Circle()
                                        .fill(Color(UIColor.systemGray6))
                                        .frame(width: 96, height: 96)
                                        .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 20)

                                // Nombre + alias
                                VStack(spacing: 4) {
                                    Text("Usuario Ejemplo")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.primary)

                                    Text("@fifafamily_user")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }

                                // Métricas rápidas
                                HStack(spacing: 18) {
                                    ProfileMetric(value: "8", label: "Lugares guardados")
                                    Divider().frame(height: 28).background(Color.black.opacity(0.08))
                                    ProfileMetric(value: "3", label: "Rutas recientes")
                                    Divider().frame(height: 28).background(Color.black.opacity(0.08))
                                    ProfileMetric(value: "2", label: "Reportes")
                                }
                                .padding(.bottom, 16)
                            }

                            // Botón Editar
                            Button { showEdit = true } label: {
                                Label("Editar", systemImage: "pencil")
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.75))
                                    .clipShape(Capsule())
                            }
                            .padding(12)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 14)

                        // Segmento estilo tabs (sin romper navegación)
                        SegmentedTabs(selected: $selectedTab, items: ["Información", "Familia", "Favoritos"])

                        Group {
                            if selectedTab == 0 {
                                ProfileSectionCard(
                                    title: "Información",
                                    rows: [
                                        .init(icon: "envelope.fill", title: "Correo", value: "correo@ejemplo.com"),
                                        .init(icon: "mappin.and.ellipse", title: "Ciudad", value: "Monterrey, N.L."),
                                        .init(icon: "globe.americas.fill", title: "Idioma", value: "Español")
                                    ]
                                )
                            } else if selectedTab == 1 {
                                ProfileSectionCard(
                                    title: "Familia",
                                    rows: [
                                        .init(icon: "person.2.fill", title: "Miembros", value: "2 adultos, 1 niño"),
                                        .init(icon: "figure.and.child.holdinghands", title: "Necesidades", value: "Cambiador / rampas")
                                    ],
                                    primaryAction: .init(title: "Gestionar integrantes", systemImage: "plus.circle.fill") {
                                        // acción para gestionar integrantes
                                    }
                                )
                            } else {
                                ProfileSectionCard(
                                    title: "Favoritos",
                                    rows: [
                                        .init(icon: "star.fill", title: "Sitios", value: "Baños familiares BBVA, Parque La Pastora"),
                                        .init(icon: "map.fill", title: "Rutas", value: "Puerta Lateral SE → Zona Lactancia Oriente")
                                    ],
                                    primaryAction: .init(title: "Ver todos", systemImage: "arrow.right") {
                                        // acción para ver todos
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)

                        // CTA grande para volver a Home
                        Button {
                            navigateToHome = true
                        } label: {
                            HStack(spacing: 10) {
                                Image(systemName: "house.fill")
                                Text("Ir a Home")
                                    .fontWeight(.semibold)
                            }
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.65)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: .black.opacity(0.12), radius: 6, y: 3)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 28)
                        
                        NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                       isActive: $navigateToHome) { EmptyView() }
                    }
                }
            }
        }
        // Sheets simuladas
        .sheet(isPresented: $showEdit) {
            VStack(spacing: 12) {
                Text("Editar Perfil")
                    .font(.title2.bold())
                Text("Aquí podrás editar tu nombre, foto e intereses.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                Button("Cerrar") { showEdit = false }
                    .padding(.top, 8)
            }
            .padding(24)
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showSettings) {
            Settings() // ya tienes esta vista
        }
    }
}

// MARK: - Componentes

private struct ProfileMetric: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SegmentedTabs: View {
    @Binding var selected: Int
    let items: [String]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(items.indices, id: \.self) { i in
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        selected = i
                    }
                } label: {
                    Text(items[i])
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(selected == i ? .white : .primary)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            Group {
                                if selected == i {
                                    LinearGradient(
                                        colors: [Color(red: 0.15, green: 0.35, blue: 0.65),
                                                 Color(red: 0.10, green: 0.30, blue: 0.60)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                } else {
                                    Color.white
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(color: .black.opacity(selected == i ? 0.15 : 0.08),
                                radius: selected == i ? 6 : 3, y: 2)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
    }
}

private struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray6))
                Image(systemName: icon).font(.system(size: 16, weight: .bold)).foregroundColor(.primary)
            }
            .frame(width: 36, height: 36)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(UIColor.secondarySystemBackground))
        )
    }
}

private struct ProfileSectionCard: View {
    struct Row { let icon: String; let title: String; let value: String }
    struct PrimaryAction { let title: String; let systemImage: String; let action: () -> Void }

    let title: String
    let rows: [Row]
    var primaryAction: PrimaryAction? = nil

    var body: some View {
        VStack(spacing: 12) {
            // Título
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                if let pa = primaryAction {
                    Button(action: pa.action) {
                        Label(pa.title, systemImage: pa.systemImage)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.08))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            VStack(spacing: 10) {
                ForEach(rows.indices, id: \.self) { i in
                    let r = rows[i]
                    ProfileRow(icon: r.icon, title: r.title, value: r.value)
                }
            }
            .padding(.bottom, 12)
        }
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color.white))
        .shadow(color: .black.opacity(0.10), radius: 8, y: 3)
    }
}

#Preview {
    Profile()
}
