import SwiftUI

struct Home: View {
    @State private var searchText = ""
    @State private var showSideMenu = false
    @State private var navigateToProfile = false
    @State private var navigateToHome = false
    @State private var navigateToSettings = false
    @State private var showSearchBar = false
    
    var body: some View {
        ZStack {
            NavigationView {
                ZStack {
                    VStack(spacing: 0) {
                        // Imagen del estadio
                        ZStack {
                            Image("Estadio BBVA")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                            
                            Color.black.opacity(0.3)
                            
                            // 🔍 Barra de búsqueda condicional
                            VStack {
                                if showSearchBar {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                        
                                        TextField("Buscar...", text: $searchText)
                                            .foregroundColor(.black)
                                        
                                        // Botón para cerrar la búsqueda
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
                        
                        // Fondo blanco con contenido
                        ZStack {
                            Color.white
                            
                            VStack(spacing: 15) {
                                // Card superior grande con imagen
                                ZStack(alignment: .topTrailing) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 230/255, green: 80/255, blue: 60/255))
                                        .frame(height: 180)
                                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                                        .padding(.horizontal, 20)
                                    
                                }
                                .padding(.top, 20)
                                .padding(.bottom, 0)
                                
                                // Fila de dos cards
                                HStack(spacing: 15) {
                                    // Card roja izquierda
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 230/255, green: 80/255, blue: 60/255))
                                        .frame(height: 200)
                                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                                    
                                    // Card amarilla derecha
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(red: 255/255, green: 190/255, blue: 50/255))
                                        .frame(height: 200)
                                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                                }
                                .padding(.horizontal, 20)
                                
                                // Card roja inferior
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 230/255, green: 80/255, blue: 60/255))
                                    .frame(height: 160)
                                    .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                                    .padding(.horizontal, 20)
                                
                                
                                // Barra de navegación inferior
                                HStack(spacing: 0) {
                                    // Botón Ubicación
                                    Button(action: {
                                        // Acción de ubicación
                                    }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: "mappin.circle.fill")
                                                .font(.system(size: 32))
                                            Text("Ubicación")
                                                .font(.system(size: 12))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                    }
                                    
                                    // Botón Home
                                    Button(action: {
                                        navigateToHome = true
                                    }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: "house.fill")
                                                .font(.system(size: 32))
                                            Text("Home")
                                                .font(.system(size: 12))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                    }
                                    
                                    // Botón Perfil
                                    Button(action: {
                                        navigateToProfile = true
                                    }) {
                                        VStack(spacing: 8) {
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 32))
                                            Text("Perfil")
                                                .font(.system(size: 12))
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.vertical, 15)
                                .background(Color(red: 30/255, green: 70/255, blue: 130/255))
                                .cornerRadius(30)
                                .padding(.horizontal, 30)
                                .padding(.bottom, 30)
                            }
                        }
                    }
                    .edgesIgnoringSafeArea(.top)
                    
                    // 🔗 Navegación a Profile
                    NavigationLink(destination: Profile().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToProfile) {
                        EmptyView()
                    }
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToHome) {
                        EmptyView()
                    }
                    NavigationLink(destination: Settings().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToSettings) {
                        EmptyView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Botón del menú lateral (izquierda)
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            withAnimation {
                                showSideMenu.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    
                    // 🔍 Botón de búsqueda (derecha)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            withAnimation {
                                showSearchBar.toggle()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            
            // MENÚ LATERAL
            if showSideMenu {
                HStack(spacing: 0) {
                    SideMenuView(showSideMenu: $showSideMenu, navigateToProfile: $navigateToProfile, navigateToHome: $navigateToHome, navigateToSettings: $navigateToSettings)
                        .frame(width: 250)
                        .transition(.move(edge: .leading))
                        .zIndex(2)
                    
                    Spacer()
                }
                .background(
                    Color.black.opacity(0.3)
                        .onTapGesture {
                            withAnimation {
                                showSideMenu = false
                            }
                        }
                )
                .zIndex(1)
            }
        }
    }
}

struct SideMenuView: View {
    @Binding var showSideMenu: Bool
    @Binding var navigateToProfile: Bool
    @Binding var navigateToHome: Bool
    @Binding var navigateToSettings: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Perfil del usuario
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToHome = true
                    }
                }
            }) {
                MenuItem(icon: "house", title: "Home")
            }
            
            MenuItem(icon: "globe", title: "Idiomas")
            MenuItem(icon: "bell", title: "Notificaciones")
            MenuItem(icon: "info.circle", title: "Sobre nosotros")
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    showSideMenu = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToSettings = true
                    }
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

