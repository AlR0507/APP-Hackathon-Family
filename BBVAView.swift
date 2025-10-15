
import SwiftUI
import MapKit

struct BBVAView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(
        center: DataStore.estadioBBVA,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var mostrarMenuLateral = false
    @State private var mostrarPanelDerecho = false
    @State private var mostrarCroquis = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // === 1️⃣ Mapa con pin del BBVA ===
            Map(coordinateRegion: $region, annotationItems: [
                AztecaPlace(title: "Estadio BBVA", coordinate: DataStore.estadioBBVA)
            ]) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    EstadioAnnotationView(title: place.title)
                        .onTapGesture { mostrarCroquis = true }
                }
            }
            .ignoresSafeArea()

            // === 2️⃣ Header superior ===
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss() // volver al mapa principal
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.top, 8)
                .padding(.bottom, 6)

                HStack {
                    Text("FIFA Family+\nEstadio BBVA")
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 8)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                LinearGradient(colors: [Color(red: 1.0, green: 0.65, blue: 0.0),
                                        Color(red: 1.0, green: 0.62, blue: 0.0)],
                               startPoint: .top, endPoint: .bottom)
                    .frame(height: 96)
                    .ignoresSafeArea(edges: .top)
                    .opacity(0.95),
                alignment: .top
            )

            // === 3️⃣ Panel lateral izquierdo (estadio selector) ===
            // === Drawer lateral izquierdo (ESTILO TARJETA, SIN FONDO SOMBREADO) ===
            if mostrarMenuLateral {
                // Usamos un HStack para “pegar” la tarjeta al borde izquierdo
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        StadiumsSideMenuView(
                            onClose: {
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    mostrarMenuLateral = false
                                }
                            },
                            onSelect: { stadium in
                                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                    mostrarMenuLateral = false
                                }
                                // Centrar mapa donde corresponde
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    region = MKCoordinateRegion(
                                        center: stadium.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                    )
                                }
                                // Si eligen Azteca y quieres abrir croquis:
                                if stadium.id == "azteca" {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        mostrarCroquis = true
                                    }
                                }
                            }
                        )
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: .black.opacity(0.18), radius: 12, x: 6, y: 0)
                        // margen superior para no chocar con la barra naranja
                        .padding(.top, 16)
                        // deja espacio para que se siga viendo la píldora azul inferior
                        .padding(.bottom, 110)
                        .padding(.leading, 12)
                        .frame(width: UIScreen.main.bounds.width * 0.78)
                        .transition(.move(edge: .leading))
                    }

                    Spacer(minLength: 0)
                }
                // Importante: SIN overlay oscuro
                .ignoresSafeArea(edges: [.bottom])   // respeta top por el padding que dimos
                .zIndex(2)
            }

            // === 4️⃣ Panel lateral derecho (servicios) ===
            if mostrarPanelDerecho {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)

                    Rectangle()
                        .fill(Color.black.opacity(0.35))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                mostrarPanelDerecho = false
                            }
                        }

                    ServiciosCercanosSidePanel(onClose: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            mostrarPanelDerecho = false
                        }
                    })
                    .frame(width: UIScreen.main.bounds.width * 0.85)
                    .transition(.move(edge: .trailing))
                }
                .ignoresSafeArea()
                .zIndex(2)
            }

            // === 5️⃣ Barra azul inferior ===
            BottomPillBar(
                onGrid: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        mostrarMenuLateral = true
                    }
                },
                onHome: {
                    withAnimation {
                        region.center = DataStore.estadioBBVA
                    }
                },
                onStore: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                        mostrarPanelDerecho = true
                    }
                }
            )
            .padding(.horizontal, 28)
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $mostrarCroquis) {
            Text("Vista de croquis para el Estadio BBVA 💙⚽️ (en desarrollo)")
                .font(.title3.bold())
                .padding()
        }
    }
}
