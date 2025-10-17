import SwiftUI
import MapKit

struct Home: View {
    // Estado existente
    @State private var searchText = ""
    @State private var showSideMenu = false
    @State private var navigateToProfile = false
    @State private var navigateToHome = false
    @State private var navigateToSettings = false
    @State private var navigateToLanguages = false
    @State private var navigateToBBVA = false
    @State private var showSearchBar = false

    // Estado para el Map miniatura
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.432608, longitude: -99.133209), // CDMX por defecto
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 0) {
                        // ====== Top image / header (si lo necesitas, déjalo) ======
                        ZStack {
                            Image("Estadio BBVA")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()

                            Color.black.opacity(0.25)

                            // 🔍 Barra de búsqueda condicional
                            VStack {
                                if showSearchBar {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)

                                        TextField("Buscar...", text: $searchText)
                                            .foregroundColor(.black)

                                        Button(action: {
                                            withAnimation {
                                                showSearchBar = false
                                                searchText = ""
                                            }
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(25)
                                    .padding(.horizontal, 20)
                                    .padding(.top, 120)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                                Spacer()
                            }
                        }
                        .frame(height: 200)

                        // ====== CONTENIDO PRINCIPAL ======
                        ZStack {
                            Color.white.ignoresSafeArea()

                            VStack(spacing: 18) {
                                // ---------- Banner rojo ----------
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color(red: 230/255, green: 80/255, blue: 60/255))
                                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                                        .padding(.top, 18)

                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("Descubre \nnuevas rutas")
                                                .font(.system(size: 32, weight: .heavy))
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.8)

                                            Text("Que nadie se quede, que todos lleguen.")
                                                .font(.system(size: 13, weight: .semibold))
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                        .padding(.leading, 20)
                                        .padding(.vertical, 18)

                                        Spacer()

                                        // Trophy (usa tu asset si lo tienes; si no, SF Symbol)
                                    }
                                }
                                .frame(height: 170)
                                .padding(.horizontal, 20)
                                
                                .overlay() {
                                    Image("world cup")
                                        .resizable()
                                        .frame(width: 220, height: 300)
                                        .foregroundColor(.yellow.opacity(0.95))
                                        .padding(EdgeInsets(top: 0, leading: 250, bottom: 37, trailing: 0))
                                }
                                    
                                // ---------- Grid principal ----------
                                HStack(alignment: .top, spacing: 16) {

                                    // Columna izquierda
                                    VStack(spacing: 16) {
                                        // Mini mapa con label "Tú estás aquí"
                                        ZStack(alignment: .bottomLeading) {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.white)
                                                .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 4)

                                            Map(coordinateRegion: $region)
                                                .disabled(true)
                                                .cornerRadius(20)

                                            Text("Tú estás aquí")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 6)
                                                .background(Color(red: 230/255, green: 80/255, blue: 60/255))
                                                .clipShape(Capsule())
                                                .padding(10)
                                        }
                                        .frame(width: 150, height: 140)

                                        // Card roja cuadrada
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(
                                                    LinearGradient(colors: [Color.red, Color.orange.opacity(0.9)],
                                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                            VStack(spacing: 6) {
                                                Image(systemName: "mappin.circle.fill")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.white)
                                                Text("Servicios\nCercanos")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .multilineTextAlignment(.center)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .onTapGesture {
                                            navigateToBBVA = true
                                        }

                                    }
                                    .frame(width: 150)

                                    // Columna derecha: card amarilla alta
                                    ZStack(alignment: .bottomLeading) {
                                        Image("familiafutbol") // imagen real de familias en estadio
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .clipped()
                                            .cornerRadius(20)
                                        LinearGradient(colors: [.black.opacity(0.1), .black.opacity(0.6)],
                                                       startPoint: .top, endPoint: .bottom)
                                            .cornerRadius(20)
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text("💡 Consejo inclusivo")
                                                .font(.caption.bold())
                                                .foregroundColor(.yellow)
                                            Text("Recuerda ubicar los accesos accesibles y zonas de lactancia al llegar al estadio.")
                                                .font(.system(size: 13))
                                                .foregroundColor(.white)
                                                .lineLimit(3)
                                        }
                                        .padding()
                                    }

                                }
                                .padding(.horizontal, 20)

                                Spacer(minLength: 10)

                                // ---------- Bottom Bar azul ----------
                                HStack(spacing: 0) {
                                    BottomBarButton(system: "mappin.circle") {
                                        navigateToBBVA = true
                                    }
                                    BottomBarButton(system: "house") {
                                        navigateToHome = true
                                    }
                                    BottomBarButton(system: "person") {
                                        navigateToProfile = true
                                    }
                                }
                                .padding(.vertical, 14)
                                .padding(.horizontal, 22)
                                .background(Color(red: 30/255, green: 70/255, blue: 130/255))
                                .clipShape(Capsule())
                                .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 100)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.top)

                    // Navegaciones invisibles
                    NavigationLink(destination: Profile().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToProfile) { EmptyView() }
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToHome) { EmptyView() }
                    NavigationLink(destination: Settings().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToSettings) { EmptyView() }
                    NavigationLink(destination: Languages().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToLanguages) { EmptyView() }
                    NavigationLink(destination: BBVAView().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToBBVA) { EmptyView() }
                }
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Menú lateral
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation { showSideMenu.toggle() }
                        }) {
                            Image(systemName: "person.crop.circle")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    // Buscar
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation { showSearchBar.toggle() }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                }
            }

            // ====== Side Menu overlay ======
            if showSideMenu {
                HStack(spacing: 0) {
                    SideMenuView(
                        showSideMenu: $showSideMenu,
                        navigateToProfile: $navigateToProfile,
                        navigateToHome: $navigateToHome,
                        navigateToSettings: $navigateToSettings,
                        navigateToLanguages: $navigateToLanguages
                    )
                    .frame(width: 250)
                    .transition(.move(edge: .leading))
                    .zIndex(2)

                    Spacer()
                }
                .background(
                    Color.black.opacity(0.3)
                        .onTapGesture {
                            withAnimation { showSideMenu = false }
                        }
                )
                .zIndex(1)
            }
        }
    }
}

// ====== Componentes auxiliares ======
private struct BottomBarButton: View {
    let system: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

struct SideMenuView: View {
    @Binding var showSideMenu: Bool
    @Binding var navigateToProfile: Bool
    @Binding var navigateToHome: Bool
    @Binding var navigateToSettings: Bool
    @Binding var navigateToLanguages: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Perfil
            VStack(alignment: .leading, spacing: 5) {
                Button(action: {
                    withAnimation {
                        showSideMenu = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigateToProfile = true
                        }
                    }
                }) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                }

                Text("Usuario")
                    .font(.headline)
                Text("correo@ejemplo.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)

            Divider().padding(.vertical, 10)

            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToHome = true }
                }
            }) {
                MenuItem(icon: "house", title: "Home")
            }
            
            
            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToLanguages = true }
                }
            }) {
                MenuItem(icon: "globe", title: "Idiomas")
            }
            MenuItem(icon: "bell", title: "Notificaciones")
            MenuItem(icon: "info.circle", title: "Sobre nosotros")

            Spacer()

            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { navigateToSettings = true }
                }
            }) {
                MenuItem(icon: "gear", title: "Ajustes")
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: 250, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .shadow(radius: 5)
    }
}

struct MenuItem: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 22))
            Text(title)
                .font(.system(size: 18))
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.red)
        }
        .foregroundColor(.black)
    }
}

#Preview {
    Home()
}
