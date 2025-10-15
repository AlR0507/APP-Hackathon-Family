import SwiftUI
import MapKit
import UIKit   // para usar UIColor.*

// MARK: - Tema y Utilidades
extension Color {
    static let brandPrimary = Color(red: 0.15, green: 0.35, blue: 0.65)
    static let brandAccent  = Color(red: 1.0,  green: 0.4,  blue: 0.2)
}

extension View {
    func cardShadow() -> some View {
        shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 2)
    }
}

// MARK: - Modelos
enum TipoAcceso: Hashable, Identifiable {
    case acceso, tunel, rampa
    var id: Self { self }
    
    var color: Color {
        switch self {
        case .acceso: return Color(red: 1.0, green: 0.4, blue: 0.2)
        case .tunel:  return Color(red: 0.6, green: 0.3, blue: 0.8)
        case .rampa:  return Color(red: 1.0, green: 0.75, blue: 0.0)
        }
    }
}

enum TipoServicio: Hashable, Identifiable {
    case banos, accesos, primerosAuxilios, lactancia
    var id: Self { self }
    
    var color: Color {
        switch self {
        case .banos:            return Color(red: 0.15, green: 0.45, blue: 0.85)
        case .accesos:          return Color(red: 1.0,  green: 0.4,  blue: 0.2)
        case .primerosAuxilios: return Color(red: 0.95, green: 0.2,  blue: 0.25)
        case .lactancia:        return Color(red: 0.6,  green: 0.3,  blue: 0.8)
        }
    }
    var titulo: String {
        switch self {
        case .banos:            return "Baños Familiares"
        case .accesos:          return "Accesos y Movilidad"
        case .primerosAuxilios: return "Primeros Auxilios"
        case .lactancia:        return "Zona de Lactancia"
        }
    }
    var imagenFondo: String {
        switch self {
        case .banos:            return "Banosfamiliares"
        case .accesos:          return "Accesos"
        case .primerosAuxilios: return "PrimerosAuxilios"
        case .lactancia:        return "ZonaLactancia"
        }
    }
}

enum Categoria: Hashable, Identifiable {
    case none, banos, accesos, primerosAuxilios, lactancia
    var id: Self { self }
}

struct DetalleUbicacion: Identifiable, Hashable {
    let id = UUID()
    let numero: String
    let tipo: TipoServicio
    let titulo: String
    let descripcion: String
    let informacionAdicional: [String]
    let servicios: [String]
    let puntoCroquis: CGPoint
    let coordinate: CLLocationCoordinate2D?
    
    static func == (lhs: DetalleUbicacion, rhs: DetalleUbicacion) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Fuente de Datos (data-driven)
enum DataStore {
    static let estadioAzteca = CLLocationCoordinate2D(latitude: 19.3028, longitude: -99.1507)
    static let estadioBBVA   = CLLocationCoordinate2D(latitude: 25.6736, longitude: -100.2440)

    // ==== Croquis interno del Azteca ====
    static func banos() -> [DetalleUbicacion] {
        [
            .init(numero: "1", tipo: .banos, titulo: "Explanada Principal - Entrada Norte",
                  descripcion: "Baño familiar ubicado estratégicamente en la entrada principal norte.",
                  informacionAdicional: ["Nivel 1 - Planta Baja", "Cerca de Puerta 1"],
                  servicios: ["Cambiador para bebés", "Espacio amplio para carriolas"],
                  puntoCroquis: CGPoint(x: -60, y: -160),
                  coordinate: estadioAzteca),
            .init(numero: "2", tipo: .banos, titulo: "Zona Palcos Club - Área Premium",
                  descripcion: "Baño familiar exclusivo en la zona VIP.",
                  informacionAdicional: ["Nivel 2 - Palco Club", "Área VIP"],
                  servicios: ["Servicio premium", "Ambiente privado"],
                  puntoCroquis: CGPoint(x: 100, y: -70),
                  coordinate: estadioAzteca),
            .init(numero: "3", tipo: .banos, titulo: "Lateral Este - Cerca Banorte",
                  descripcion: "Ubicado en el lateral este.",
                  informacionAdicional: ["Nivel 1 - Concourse", "Lateral Este"],
                  servicios: ["Fácil acceso", "Señalización clara"],
                  puntoCroquis: CGPoint(x: 160, y: -20),
                  coordinate: estadioAzteca),
            .init(numero: "4", tipo: .banos, titulo: "Lateral Oeste - Cerca Sta Ursula",
                  descripcion: "Baño familiar en el lateral oeste.",
                  informacionAdicional: ["Nivel 1 - Concourse", "Lateral Oeste"],
                  servicios: ["Amplio espacio", "Ventilación natural"],
                  puntoCroquis: CGPoint(x: -160, y: -20),
                  coordinate: estadioAzteca),
            .init(numero: "5", tipo: .banos, titulo: "Acceso Sur - Cabecera Sur",
                  descripcion: "Ideal para familias que llegan del sur.",
                  informacionAdicional: ["Nivel 1 - Planta Baja", "Cabecera Sur"],
                  servicios: ["Entrada directa", "Fácil estacionamiento"],
                  puntoCroquis: CGPoint(x: 0, y: 160),
                  coordinate: estadioAzteca),
            .init(numero: "6", tipo: .banos, titulo: "Nivel Intermedio - Área Comida",
                  descripcion: "Ubicado cerca del área de comida.",
                  informacionAdicional: ["Nivel 1.5 - Mezzanine", "Área de Comida"],
                  servicios: ["Cerca de servicios", "Espacio tranquilo"],
                  puntoCroquis: CGPoint(x: -100, y: -70),
                  coordinate: estadioAzteca)
        ]
    }
    
    static func accesos() -> [DetalleUbicacion] {
        [
            .init(numero: "A", tipo: .accesos, titulo: "Túnel Principal Norte",
                  descripcion: "Túnel principal de acceso norte.",
                  informacionAdicional: ["Túnel Principal", "Acceso Norte"],
                  servicios: ["Acceso amplio", "Iluminación completa"],
                  puntoCroquis: CGPoint(x: 0, y: -155),
                  coordinate: estadioAzteca),
            .init(numero: "B", tipo: .accesos, titulo: "Rampa VIP - Zona Palcos",
                  descripcion: "Rampa de acceso exclusiva para zonas VIP.",
                  informacionAdicional: ["Rampa Accesible", "Área VIP"],
                  servicios: ["Para carriolas y sillas", "Inclinación suave"],
                  puntoCroquis: CGPoint(x: 110, y: -130),
                  coordinate: estadioAzteca),
            .init(numero: "C", tipo: .accesos, titulo: "Acceso Lateral Este",
                  descripcion: "Acceso principal del lateral este.",
                  informacionAdicional: ["Acceso Principal", "Lateral Este"],
                  servicios: ["Puertas amplias", "Bien iluminado"],
                  puntoCroquis: CGPoint(x: 155, y: -40),
                  coordinate: estadioAzteca),
            .init(numero: "D", tipo: .accesos, titulo: "Acceso Lateral Oeste",
                  descripcion: "Acceso del lateral oeste.",
                  informacionAdicional: ["Acceso Principal", "Lateral Oeste"],
                  servicios: ["Estacionamiento cercano", "Acceso rápido"],
                  puntoCroquis: CGPoint(x: -155, y: -40),
                  coordinate: estadioAzteca),
            .init(numero: "E", tipo: .accesos, titulo: "Túnel Sur - Acceso Principal",
                  descripcion: "Túnel de acceso sur.",
                  informacionAdicional: ["Túnel Secundario", "Acceso Sur"],
                  servicios: ["Conexión rápida", "Menos congestionado"],
                  puntoCroquis: CGPoint(x: 0, y: 155),
                  coordinate: estadioAzteca),
            .init(numero: "F", tipo: .accesos, titulo: "Rampa Intermedia",
                  descripcion: "Rampa interna que conecta diferentes niveles.",
                  informacionAdicional: ["Rampa Interna", "Área Central"],
                  servicios: ["Entre niveles", "Fácil acceso"],
                  puntoCroquis: CGPoint(x: -110, y: -130),
                  coordinate: estadioAzteca)
        ]
    }
    
    static func primerosAuxilios() -> [DetalleUbicacion] {
        [
            .init(numero: "M1", tipo: .primerosAuxilios, titulo: "Área Médica Principal",
                  descripcion: "Punto central de atención médica.",
                  informacionAdicional: ["Enfermería Principal", "Zona Poniente"],
                  servicios: ["Personal médico", "Botiquín completo"],
                  puntoCroquis: CGPoint(x: -140, y: -30),
                  coordinate: estadioAzteca),
            .init(numero: "M2", tipo: .primerosAuxilios, titulo: "Módulo Norte",
                  descripcion: "Puesto médico en el anillo norte.",
                  informacionAdicional: ["Puesto Temporal", "Anillo Norte"],
                  servicios: ["Atención básica", "Botiquín esencial"],
                  puntoCroquis: CGPoint(x: -40, y: -140),
                  coordinate: estadioAzteca),
            .init(numero: "M3", tipo: .primerosAuxilios, titulo: "Módulo Sur",
                  descripcion: "Punto de apoyo médico en la zona sur.",
                  informacionAdicional: ["Puesto de Emergencia", "Zona Sur"],
                  servicios: ["Atención de emergencia", "Botiquín avanzado"],
                  puntoCroquis: CGPoint(x: -30, y: 130),
                  coordinate: estadioAzteca)
        ]
    }
    
    static func lactancia() -> [DetalleUbicacion] {
        [
            .init(numero: "L1", tipo: .lactancia, titulo: "Sala Lactancia Principal",
                  descripcion: "Sala principal de lactancia en la explanada norte.",
                  informacionAdicional: ["Nivel 1 - Explanada", "Zona familiar"],
                  servicios: ["Sala privada", "Sillones reclinables", "Cambiadores higiénicos"],
                  puntoCroquis: CGPoint(x: -40, y: -150),
                  coordinate: estadioAzteca),
            .init(numero: "L2", tipo: .lactancia, titulo: "Sala Lactancia Lateral Este",
                  descripcion: "Sala secundaria en el lateral este.",
                  informacionAdicional: ["Nivel 1 - Lateral Este", "Área Banorte"],
                  servicios: ["Cabinas privadas", "Área de cambiadores", "Lavabo para biberones"],
                  puntoCroquis: CGPoint(x: 130, y: 20),
                  coordinate: estadioAzteca)
        ]
    }
    
    static func ubicaciones(for categoria: Categoria) -> [DetalleUbicacion] {
        switch categoria {
        case .banos:            return banos()
        case .accesos:          return accesos()
        case .primerosAuxilios: return primerosAuxilios()
        case .lactancia:        return lactancia()
        case .none:             return []
        }
    }
    
    // ==== Servicios estáticos Azteca (como los tenías) ====
    static func familyServicesNearAzteca() -> [FamilyService] {
        [
            FamilyService(
                name: "Farmacia Guadalajara Huipulco",
                category: .farmacia,
                coordinate: CLLocationCoordinate2D(latitude: 19.29573, longitude: -99.14572),
                description: "Farmacia 24 horas con venta de pañales, medicamentos básicos y artículos de higiene infantil.",
                amenities: ["Pañales y fórmulas", "Medicamentos pediátricos", "Estacionamiento propio"],
                hours: "Abierto 24 horas",
                phone: "55 5683 9133"
            ),
            FamilyService(
                name: "Super Chedraui Tlalpan",
                category: .supermercado,
                coordinate: CLLocationCoordinate2D(latitude: 19.29445, longitude: -99.14785),
                description: "Supermercado con área de bebés, alimentos para niños y baños familiares.",
                amenities: ["Carrito para bebés", "Área de comida", "Baños amplios"],
                hours: "7:00 a 22:00",
                phone: "55 5483 0100"
            ),
            FamilyService(
                name: "Hospital Médica Sur",
                category: .clinica,
                coordinate: CLLocationCoordinate2D(latitude: 19.30340, longitude: -99.14650),
                description: "Centro hospitalario con atención pediátrica y urgencias 24 horas.",
                amenities: ["Urgencias 24h", "Pediatría", "Farmacia interna"],
                hours: "Abierto 24 horas",
                phone: "55 5424 7200"
            ),
            FamilyService(
                name: "Cafetería Starbucks Huipulco",
                category: .cafeteria,
                coordinate: CLLocationCoordinate2D(latitude: 19.29512, longitude: -99.14933),
                description: "Espacio cómodo con wifi, cambiador para bebés y bebidas frías/calientes.",
                amenities: ["WiFi", "Cambiador en baño", "Sillas altas"],
                hours: "6:00 a 22:00",
                phone: nil
            ),
            FamilyService(
                name: "Parque de la Bombilla Infantil",
                category: .parque,
                coordinate: CLLocationCoordinate2D(latitude: 19.29792, longitude: -99.14790),
                description: "Área verde con juegos infantiles y bancas sombreadas.",
                amenities: ["Área de juegos", "Baños públicos", "Sombra"],
                hours: "6:00 a 19:00",
                phone: nil
            ),
            FamilyService(
                name: "BabyMart - Tienda de Bebés",
                category: .bebes,
                coordinate: CLLocationCoordinate2D(latitude: 19.29850, longitude: -99.15120),
                description: "Tienda con artículos para bebés, ropa, biberones, carriolas y más.",
                amenities: ["Carriolas", "Ropa de bebé", "Fórmulas infantiles"],
                hours: "10:00 a 20:00",
                phone: "55 5372 1200"
            ),
            FamilyService(
                name: "Estacionamiento Estadio Azteca Sur",
                category: .estacionamiento,
                coordinate: CLLocationCoordinate2D(latitude: 19.30080, longitude: -99.15160),
                description: "Estacionamiento techado con espacios amplios y acceso peatonal seguro.",
                amenities: ["Rampas", "Cajones amplios", "Seguridad"],
                hours: "Abierto durante eventos",
                phone: nil
            )
        ]
    }

    // ==== Servicios estáticos BBVA (mock para que se vean pines) ====
    // Si ya tienes este método en DataStore+BBVA.swift, puedes borrar este y usar el tuyo.

    // Modelo para listado de estadios en el panel
    struct Stadium: Identifiable, Equatable, Hashable {
        let id: String            // "azteca", "bbva", etc.
        let name: String
        let city: String
        let imageName: String     // EstadioAztecaaa / BBVAEstadio
        let coordinate: CLLocationCoordinate2D

        static func == (lhs: Stadium, rhs: Stadium) -> Bool { lhs.id == rhs.id }
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }

    static func stadiums() -> [Stadium] {
        [
            Stadium(
                id: "azteca",
                name: "Estadio Azteca",
                city: "Ciudad de México",
                imageName: "EstadioAztecaaa",
                coordinate: DataStore.estadioAzteca
            ),
            Stadium(
                id: "bbva",
                name: "Estadio BBVA",
                city: "Monterrey, NL",
                imageName: "BBVAEstadio",
                coordinate: DataStore.estadioBBVA
            )
        ]
    }
}

// MARK: - Pins
struct PinByTipo: View {
    let tipo: TipoServicio
    let numero: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(tipo.color)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(.white, lineWidth: 2))
                Text(numero)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            Triangle()
                .fill(tipo.color)
                .frame(width: 8, height: 12)
                .offset(y: -1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(tipo.titulo) \(numero)")
        .accessibilityHint("Toca para ver detalles")
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.closeSubpath()
        return p
    }
}

// MARK: - Botón de Categoría
struct CategoriaButton: View {
    let categoria: Categoria
    let icon: String
    let color: Color
    let label: String
    @Binding var actual: Categoria
    
    var isActive: Bool { actual == categoria }
    
    var body: some View {
        Button {
            actual = (isActive ? .none : categoria)
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(isActive ? color.opacity(0.9) : color)
                        .frame(width: 50, height: 50)
                        .cardShadow()
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                Text(label)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
        .accessibilityHint(isActive ? "Desactivar filtro" : "Activar filtro")
    }
}

// MARK: - Vista Croquis Interno
struct AztecaCroquisView: View {
    @State private var categoriaSeleccionada: Categoria = .none
    @State private var detalleSeleccionado: DetalleUbicacion? = nil
    @State private var mostrarMapaExterior = false
    
    private let ancho: CGFloat = 350
    private let alto: CGFloat  = 400
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.3, blue: 0.6),
                                                       Color(red: 0.15, green: 0.35, blue: 0.65)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    CategoriaButton(categoria: .banos, icon: "figure.and.child.holdinghands",
                                    color: TipoServicio.banos.color, label: "Baños",
                                    actual: $categoriaSeleccionada)
                    CategoriaButton(categoria: .accesos, icon: "figure.walk.motion",
                                    color: TipoServicio.accesos.color, label: "Accesos",
                                    actual: $categoriaSeleccionada)
                    CategoriaButton(categoria: .primerosAuxilios, icon: "cross.case.fill",
                                    color: TipoServicio.primerosAuxilios.color, label: "Auxilios",
                                    actual: $categoriaSeleccionada)
                    CategoriaButton(categoria: .lactancia, icon: "drop.fill",
                                    color: TipoServicio.lactancia.color, label: "Lactancia",
                                    actual: $categoriaSeleccionada)
                    
                    Spacer()
                    
                    Button {
                        mostrarMapaExterior = true
                    } label: {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.25))
                            .clipShape(Circle())
                            .cardShadow()
                            .accessibilityLabel("Volver al mapa exterior")
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                VStack(spacing: 4) {
                    Text("FIFA Family+")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    Text("Estadio Azteca")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 8)
                
                ZStack {
                    Image("EstadioAzteca")
                        .resizable()
                        .scaledToFill()
                        .frame(width: ancho, height: alto)
                        .clipped()
                        .cornerRadius(24)
                        .cardShadow()
                    
                    ForEach(DataStore.ubicaciones(for: categoriaSeleccionada)) { u in
                        PinByTipo(tipo: u.tipo, numero: u.numero)
                            .offset(x: u.puntoCroquis.x, y: u.puntoCroquis.y)
                            .onTapGesture { detalleSeleccionado = u }
                    }
                }
                .frame(width: ancho, height: alto)
                
                VStack(spacing: 6) {
                    Text(instructionText(for: categoriaSeleccionada))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    Text("📍 Las ubicaciones mostradas son aproximadas")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .sheet(item: $detalleSeleccionado) { DetalleUbicacionSheetView(detalle: $0) }
        .sheet(isPresented: $mostrarMapaExterior) { MapaExteriorView() }
    }
    
    private func instructionText(for cat: Categoria) -> String {
        switch cat {
        case .banos:            return "Toca cualquier pin azul para ver detalles"
        case .accesos:          return "Selecciona un pin para ver información del acceso"
        case .primerosAuxilios: return "Toca un pin rojo para ver servicios médicos"
        case .lactancia:        return "Selecciona un pin para zonas de lactancia"
        case .none:             return "Selecciona un servicio para comenzar"
        }
    }
}

// MARK: - Mapa Exterior
struct AztecaPlace: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    static func == (lhs: AztecaPlace, rhs: AztecaPlace) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Servicios familiares cercanos (nuevos)
enum ServiceCategory: String, CaseIterable, Identifiable, Hashable {
    case farmacia, supermercado, bebes, clinica, estacionamiento, cafeteria, parque, cajero
    var id: Self { self }

    var color: Color {
        switch self {
        case .farmacia:        return Color(red: 0.10, green: 0.65, blue: 0.35)
        case .supermercado:    return Color(red: 0.20, green: 0.45, blue: 0.95)
        case .bebes:           return Color(red: 0.60, green: 0.30, blue: 0.80)
        case .clinica:         return Color(red: 0.95, green: 0.20, blue: 0.25)
        case .estacionamiento: return Color(red: 1.00, green: 0.75, blue: 0.00)
        case .cafeteria:       return Color(red: 0.95, green: 0.55, blue: 0.18)
        case .parque:          return Color(red: 0.15, green: 0.65, blue: 0.35)
        case .cajero:          return Color.gray
        }
    }

    var icon: String {
        switch self {
        case .farmacia:        return "cross.case.fill"
        case .supermercado:    return "cart.fill"
        case .bebes:           return "figure.and.child.holdinghands"
        case .clinica:         return "stethoscope"
        case .estacionamiento: return "parkingsign.circle.fill"
        case .cafeteria:       return "cup.and.saucer.fill"
        case .parque:          return "figure.play"
        case .cajero:          return "banknote.fill"
        }
    }

    var title: String {
        switch self {
        case .farmacia:        return "Farmacia"
        case .supermercado:    return "Supermercado"
        case .bebes:           return "Bebés & Pañales"
        case .clinica:         return "Clínica"
        case .estacionamiento: return "Estacionamiento"
        case .cafeteria:       return "Cafetería"
        case .parque:          return "Parque"
        case .cajero:          return "Cajero"
        }
    }
}

struct FamilyService: Identifiable, Hashable, Equatable {
    let id: UUID
    let name: String
    let category: ServiceCategory
    let coordinate: CLLocationCoordinate2D
    let description: String
    let amenities: [String]
    let hours: String
    let phone: String?
    let verified: Bool   // lo dejamos, pero ya no se usa para filtrar

    init(id: UUID = UUID(),
         name: String,
         category: ServiceCategory,
         coordinate: CLLocationCoordinate2D,
         description: String,
         amenities: [String],
         hours: String,
         phone: String?,
         verified: Bool = false) {
        self.id = id
        self.name = name
        self.category = category
        self.coordinate = coordinate
        self.description = description
        self.amenities = amenities
        self.hours = hours
        self.phone = phone
        self.verified = verified
    }

    static func == (lhs: FamilyService, rhs: FamilyService) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// Subvista para el pin (reduce carga del type-checker)
struct EstadioAnnotationView: View {
    let title: String
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 44, height: 44)
                    .overlay(Circle().stroke(.white, lineWidth: 3))
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 2)
                if UIImage(named: "FIFAFamilyPlus") != nil {
                    Image("FIFAFamilyPlus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .accessibilityHidden(true)
                } else {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.red)
                .cornerRadius(4)
        }
    }
}

struct ServicePinView: View {
    let category: ServiceCategory
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .fill(category.color)
                    .frame(width: 30, height: 30)
                    .overlay(Circle().stroke(.white, lineWidth: 2))
                Image(systemName: category.icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            Triangle()
                .fill(category.color)
                .frame(width: 8, height: 10)
                .offset(y: -1)
        }
    }
}

enum MapPoint: Identifiable {
    case estadio(AztecaPlace)
    case servicio(FamilyService)

    var id: String {
        switch self {
        case .estadio(let p):  return "estadio-\(p.id)"
        case .servicio(let s): return "servicio-\(s.id)"
        }
    }

    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .estadio(let p):  return p.coordinate
        case .servicio(let s): return s.coordinate
        }
    }
}

// MARK: - Vista principal del mapa (con servicios estáticos)
struct MapaExteriorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(
        center: DataStore.estadioAzteca,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var mostrarCroquis = false
    @State private var mostrarTiendas = false
    @State private var mostrarMenuLateral = false
    @State private var selectedService: FamilyService? = nil
    @State private var mostrarServicios = false
    @State private var mostrarPanelDerecho = false

    // Puntos combinados: 2 estadios + servicios estáticos (Azteca + BBVA)
    private var points: [MapPoint] {
        let azteca = MapPoint.estadio(AztecaPlace(title: "Estadio Azteca",
                                                  coordinate: DataStore.estadioAzteca))
        let bbva   = MapPoint.estadio(AztecaPlace(title: "Estadio BBVA",
                                                  coordinate: DataStore.estadioBBVA))
        let serviciosAzteca = DataStore.familyServicesNearAzteca().map { MapPoint.servicio($0) }
        let serviciosBBVA   = DataStore.familyServicesNearBBVA().map { MapPoint.servicio($0) }
        return [azteca, bbva] + serviciosAzteca + serviciosBBVA
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // === 1️⃣ Mapa con pines ===
            Map(coordinateRegion: $region, annotationItems: points, annotationContent: { point in
                MapAnnotation(coordinate: point.coordinate) {
                    ZStack {
                        Circle().fill(Color.clear).frame(width: 1, height: 1)
                        switch point {
                        case .estadio(let place):
                            EstadioAnnotationView(title: place.title)
                                .allowsHitTesting(true)
                                .transition(.opacity)
                                .onTapGesture { mostrarCroquis = true }
                                .id("estadio-\(place.id)")
                        case .servicio(let service):
                            ServicePinView(category: service.category)
                                .allowsHitTesting(true)
                                .transition(.scale.combined(with: .opacity))
                                .onTapGesture { selectedService = service }
                                .id("servicio-\(service.id)")
                        }
                    }
                }
            })
            .ignoresSafeArea()

            // === 2️⃣ Header naranja (sin sombreado global) ===
            VStack(spacing: 0) {
                HStack {
                    Button { dismiss() } label: {
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
                    Text("FIFA Family+\nServicios Cercanos")
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

            // === 3️⃣ Panel lateral izquierdo (estadios) sin capa oscura ===
            if mostrarMenuLateral {
                HStack(spacing: 0) {
                    StadiumsSideMenuView(
                        onClose: {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                mostrarMenuLateral = false
                            }
                        },
                        onSelect: { stadium in
                            withAnimation(.easeInOut(duration: 1.0)) {
                                region = MKCoordinateRegion(
                                    center: stadium.coordinate,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            }
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                mostrarMenuLateral = false
                            }
                        }
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.78)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: .black.opacity(0.18), radius: 12, x: 6, y: 0)
                    .padding(.top, 16)
                    .padding(.bottom, 110)
                    .padding(.leading, 12)
                    .transition(.move(edge: .leading))

                    Spacer(minLength: 0)
                }
                .ignoresSafeArea(edges: [.bottom])
                .zIndex(2)
            }

            // === 4️⃣ Panel lateral derecho (lista servicios) ===
            if mostrarPanelDerecho {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
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
                        region.center = DataStore.estadioAzteca
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
        // Sheets
        .fullScreenCover(isPresented: $mostrarCroquis) { AztecaCroquisView() }
        .sheet(isPresented: $mostrarTiendas) {
            VistaTiendasSheet().presentationDetents([.medium, .large])
        }
        .sheet(item: $selectedService) { service in
            FamilyServiceSheet(service: service)
        }
        .sheet(isPresented: $mostrarServicios) { ServiciosCercanosSheet() }
    }
}

// MARK: - Drawer lateral izquierdo (Grid)
struct GridSideMenuView: View {
    var onClose: () -> Void
    var onOpenCroquis: () -> Void
    
    private let items: [GridItemData] = [
        .init(title: "Baños Familiares - Entrada Norte",
              subtitle: "Nivel 1 · Cerca de Puerta 1",
              imageName: "BanosFamiliares",
              badges: ["Cambiador", "Carriolas"],
              distance: "120 m"),
        .init(title: "Sala de Lactancia - Explanada",
              subtitle: "Nivel 1 · Zona familiar",
              imageName: "ZonaLactancia",
              badges: ["Privado", "Sillones", "Cambiadores"],
              distance: "180 m"),
        .init(title: "Primeros Auxilios - Área Principal",
              subtitle: "Zona Poniente",
              imageName: "PrimerosAuxilios",
              badges: ["Emergencias", "Personal médico"],
              distance: "240 m"),
        .init(title: "Acceso Rampa VIP",
              subtitle: "Área Palcos",
              imageName: "Accesos",
              badges: ["Accesible", "Inclinación suave"],
              distance: "200 m")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header del drawer
            HStack {
                Text("FIFA Family+")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemBackground))
            
            // Lista
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        GridItemRow(item: item) {
                            onOpenCroquis()
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 20)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.25), radius: 10, x: 4, y: 0)
        )
    }
}

// MARK: - Panel lateral derecho con lista de servicios
struct ServiciosCercanosSidePanel: View {
    var onClose: () -> Void
    private let servicios = DataStore.familyServicesNearAzteca() + DataStore.familyServicesNearBBVA()
    @State private var selectedService: FamilyService? = nil
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Servicios Familiares")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.black.opacity(0.08))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Divider().background(Color.black.opacity(0.15))
                
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(servicios) { service in
                            Button {
                                selectedService = service
                            } label: {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(service.category.color.opacity(0.9))
                                            .frame(width: 46, height: 46)
                                        Image(systemName: service.category.icon)
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .bold))
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(service.name)
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                        Text(service.category.title)
                                            .font(.system(size: 12))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                        .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.bottom, 20)
                    .padding(.top, 10)
                }
            }
        }
        .sheet(item: $selectedService) { service in
            FamilyServiceSheet(service: service)
        }
    }
}

// MARK: - Grid (sheet)
enum GridMenuAction { case openCroquis, close }

struct GridItemData: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let badges: [String]
    let distance: String
}

private struct BadgesView: View {
    let badges: [String]
    var body: some View {
        HStack(spacing: 6) {
            ForEach(badges, id: \.self) { b in
                Text(b)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }
}

struct GridItemRow: View {
    let item: GridItemData
    var onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Thumbnail (con fallback)
                if UIImage(named: item.imageName) != nil {
                    Image(item.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 84, height: 64)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.15))
                        Image(systemName: "photo")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 84, height: 64)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    Text(item.subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    HStack(spacing: 6) {
                        BadgesView(badges: Array(item.badges.prefix(3)))
                        Spacer()
                        Label(item.distance, systemImage: "location")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(UIColor.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(item.title), \(item.subtitle), a \(item.distance)")
    }
}

// MARK: - Sheet de Tiendas / Servicios
struct VistaTiendasSheet: View {
    var body: some View {
        NavigationView {
            List {
                Section("Tiendas cercanas") {
                    Label("Mini súper familiar", systemImage: "cart.fill")
                    Label("Farmacia", systemImage: "cross.case.fill")
                    Label("Kiosco oficial", systemImage: "bag.fill")
                }
                Section("Servicios útiles") {
                    Label("Sala de lactancia", systemImage: "drop.fill")
                    Label("Baños familiares", systemImage: "figure.and.child.holdinghands")
                    Label("Primeros auxilios", systemImage: "bandage.fill")
                }
            }
            .navigationTitle("Tiendas y servicios")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Sheet de Servicios Cercanos
struct ServiciosCercanosSheet: View {
    @Environment(\.dismiss) private var dismiss
    let servicios = DataStore.familyServicesNearAzteca() + DataStore.familyServicesNearBBVA()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Servicios Familiares Cercanos")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.12))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
            Divider()
            
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(servicios) { service in
                        ServicioCardView(service: service)
                            .padding(.horizontal, 12)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
        .background(Color(UIColor.systemBackground))
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Vista de cada servicio en la lista
struct ServicioCardView: View {
    let service: FamilyService
    @State private var showSheet = false
    
    var body: some View {
        Button { showSheet = true } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(service.category.color.opacity(0.85))
                        .frame(width: 52, height: 52)
                    Image(systemName: service.category.icon)
                        .foregroundColor(.white)
                        .font(.system(size: 22, weight: .bold))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(service.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    Text(service.category.title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    Text(service.hours)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 14)
                .fill(Color(UIColor.secondarySystemBackground)))
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showSheet) {
            FamilyServiceSheet(service: service)
        }
    }
}

// MARK: - Barra inferior (píldora)
struct BottomPillBar: View {
    var onGrid: () -> Void
    var onHome: () -> Void
    var onStore: () -> Void
    
    var body: some View {
        HStack(spacing: 60) {
            Button(action: onGrid) {
                Image(systemName: "square.grid.2x2")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .accessibilityLabel("Categorías")
            }
            Button(action: onHome) {
                Image(systemName: "house.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .accessibilityLabel("Centro del mapa")
            }
            Button(action: onStore) {
                Image(systemName: "storefront.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .accessibilityLabel("Tiendas y servicios")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.brandPrimary)
                .opacity(0.98)
        )
        .cardShadow()
    }
}

// MARK: - Detalle + Reporte
struct DetalleUbicacionSheetView: View {
    let detalle: DetalleUbicacion
    @Environment(\.dismiss) private var dismiss
    @State private var mostrarReporte = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.3, blue: 0.6),
                                                       Color(red: 0.15, green: 0.35, blue: 0.65)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .semibold))
                            Text("Atrás").font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.black.opacity(0.2))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Image(detalle.tipo.imagenFondo)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 240)
                            .clipped()
                        
                        HStack(alignment: .top, spacing: 16) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(detalle.titulo)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.primary)
                                Text(detalle.tipo.titulo)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            ZStack {
                                Circle()
                                    .fill(detalle.tipo.color)
                                    .frame(width: 50, height: 50)
                                    .cardShadow()
                                Text(detalle.numero)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                        
                        Text(detalle.descripcion)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Divider().padding(.horizontal, 20)
                        
                        HStack(alignment: .top, spacing: 24) {
                            InfoListBlock(title: "UBICACIÓN",
                                          bullets: detalle.informacionAdicional,
                                          color: detalle.tipo.color)
                            InfoListBlock(title: "SERVICIOS",
                                          bullets: detalle.servicios,
                                          color: detalle.tipo.color)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                        
                        VStack(spacing: 12) {
                            Button {
                                mostrarReporte = true
                            } label: {
                                HStack {
                                    Image(systemName: "flag.fill")
                                        .font(.system(size: 14, weight: .semibold))
                                    Text("Enviar Reporte")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .foregroundColor(.white)
                                .background(Color.brandAccent)
                                .cornerRadius(10)
                                .cardShadow()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                    .background(Color.white)
                }
            }
        }
        .sheet(isPresented: $mostrarReporte) {
            ReporteFormularioView(detalle: detalle)
        }
    }
}

// MARK: - Hoja de servicio llamativa
struct FamilyServiceSheet: View {
    let service: FamilyService
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    private var headerGradient: LinearGradient {
        LinearGradient(
            colors: [service.category.color, service.category.color.opacity(0.65)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var categoryEmoji: String {
        switch service.category {
        case .farmacia:        return "💊"
        case .supermercado:    return "🛒"
        case .bebes:           return "👶"
        case .clinica:         return "🏥"
        case .estacionamiento: return "🅿️"
        case .cafeteria:       return "☕️"
        case .parque:          return "🌳"
        case .cajero:          return "🏧"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // HEADER
            ZStack(alignment: .topTrailing) {
                headerGradient
                    .frame(height: 160)
                    .overlay(
                        ZStack {
                            Circle().fill(Color.white.opacity(0.15)).frame(width: 180, height: 180).offset(x: 120, y: -60)
                            Circle().fill(Color.white.opacity(0.10)).frame(width: 140, height: 140).offset(x: -120, y: 40)
                            Circle().fill(Color.white.opacity(0.08)).frame(width: 90, height: 90).offset(x: 40, y: 60)
                        }
                    )
                    .overlay(
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 72, height: 72)
                                Image(systemName: service.category.icon)
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(service.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                HStack(spacing: 8) {
                                    Text("\(categoryEmoji) \(service.category.title)")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.95))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.18))
                                        .clipShape(Capsule())
                                    
                                    Text(service.hours)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.95))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.white.opacity(0.18))
                                        .clipShape(Capsule())
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 50)
                    )
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding(12)
            }
            
            // CONTENIDO
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Descripción
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Descripción")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.secondary)
                        Text(service.description)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color(UIColor.secondarySystemBackground)))
                    
                    // Amenidades (chips)
                    if !service.amenities.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Amenidades")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.secondary)
                            FlexibleChips(items: service.amenities) { chip in
                                Text(chip)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(service.category.color)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(service.category.color.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(UIColor.secondarySystemBackground)))
                    }
                    
                    // Mini mapa de referencia
                    MiniMapPreview(coordinate: service.coordinate, title: service.name, color: service.category.color)
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // Acción
                    HStack(spacing: 12) {
                        ActionButton(title: "Cómo llegar", systemImage: "map.fill") {
                            openInAppleMaps(service: service)
                        }
                    }
                }
                .padding(16)
            }
            .background(Color(UIColor.systemBackground))
        }
        .presentationDetents([.large, .medium])
        .presentationDragIndicator(.visible)
    }
    
    private func openInAppleMaps(service: FamilyService) {
        let placemark = MKPlacemark(coordinate: service.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = service.name
        item.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

// MARK: - Chips flexibles en varias líneas
struct FlexibleChips<Content: View>: View {
    let items: [String]
    let content: (String) -> Content
    
    @State private var totalHeight: CGFloat = .zero
    var body: some View {
        VStack {
            GeometryReader { geo in
                self.generateContent(in: geo)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .padding(.trailing, 8)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height + 8
                        }
                        let result = width
                        if item == items.last { width = 0 } else { width -= d.width }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last { height = 0 }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        GeometryReader { geo -> Color in
            DispatchQueue.main.async { binding.wrappedValue = -geo.frame(in: .local).origin.y }
            return .clear
        }
    }
}

// MARK: - Mini mapa con pin sencillo
struct MiniMapPreview: View {
    let coordinate: CLLocationCoordinate2D
    let title: String
    let color: Color
    
    @State private var region: MKCoordinateRegion
    
    init(coordinate: CLLocationCoordinate2D, title: String, color: Color) {
        self.coordinate = coordinate
        self.title = title
        self.color = color
        _region = State(initialValue: MKCoordinateRegion(center: coordinate,
                                                         span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035)))
    }
    private struct IdentifiableTitle: Identifiable { let id: UUID; let name: String }
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [IdentifiableTitle(id: UUID(), name: title)]) { item in
            MapAnnotation(coordinate: coordinate) {
                VStack(spacing: 2) {
                    Circle().fill(color).frame(width: 16, height: 16).overlay(Circle().stroke(.white, lineWidth: 2))
                    Triangle().fill(color).frame(width: 6, height: 8).offset(y: -1)
                }
                .accessibilityLabel(item.name)
            }
        }
        .disabled(true)
    }
}

// MARK: - Botón de acción
struct ActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .background(
                    LinearGradient(colors: [Color.black.opacity(0.85), Color.black.opacity(0.65)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct InfoListBlock: View {
    let title: String
    let bullets: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
            VStack(alignment: .leading, spacing: 10) {
                ForEach(bullets, id: \.self) { s in
                    HStack(spacing: 10) {
                        Circle().fill(color).frame(width: 5, height: 5)
                        Text(s).font(.system(size: 14))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ReporteFormularioView: View {
    let detalle: DetalleUbicacion
    @Environment(\.dismiss) private var dismiss
    @State private var comentario = ""
    @State private var isSending = false
    @State private var errorMessage: String?
    @FocusState private var focus: Bool
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.3, blue: 0.6),
                                                       Color(red: 0.15, green: 0.35, blue: 0.65)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            .onTapGesture { focus = false }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                Spacer()
                
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.brandPrimary)
                            .frame(width: 50, height: 50)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Usuario").font(.system(size: 16, weight: .bold))
                            Text("juan_pablo_silva")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tu comentario:")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.secondary)
                                TextEditor(text: $comentario)
                                    .font(.system(size: 14))
                                    .frame(height: 120)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1))
                                    .focused($focus)
                                    .accessibilityLabel("Campo de comentario")
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ubicación:")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.secondary)
                                Image(detalle.tipo.imagenFondo)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .clipped()
                                    .cornerRadius(8)
                                    .accessibilityHidden(true)
                            }
                            
                            if let error = errorMessage {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                    Text(error).font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.yellow)
                                .padding(10)
                                .background(Color.yellow.opacity(0.15))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    
                    VStack(spacing: 12) {
                        Button {
                            Task { await enviarReporte() }
                        } label: {
                            Group {
                                if isSending {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("Publicar").font(.system(size: 16, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundColor(.white)
                            .background(Color.brandAccent)
                            .cornerRadius(10)
                            .cardShadow()
                        }
                        .disabled(isSending || comentario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity((isSending || comentario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color.white)
                .cornerRadius(20)
                .cardShadow()
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
    
    private func enviarReporte() async {
        errorMessage = nil
        isSending = true
        defer { isSending = false }
        
        guard let url = URL(string: "https://formspree.io/f/xzzjjqaj") else {
            errorMessage = "URL inválida."
            return
        }
        
        let mensaje = """
        NUEVO REPORTE DEL USUARIO

        Ubicación: \(detalle.titulo)
        Número: \(detalle.numero)
        Tipo: \(detalle.tipo.titulo)
        Usuario: juan_pablo_silva
        Fecha: \(ISO8601DateFormatter().string(from: Date()))

        COMENTARIO:
        \(comentario)
        """
        
        let payload: [String: Any] = [
            "email": "usuario@example.com",
            "message": mensaje
        ]
        
        do {
            let body = try JSONSerialization.data(withJSONObject: payload)
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = body
            
            let (_, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) {
                dismissalToast()
            } else {
                errorMessage = "No se pudo enviar el reporte. Intenta más tarde."
            }
        } catch {
            errorMessage = "Error de red: \(error.localizedDescription)"
        }
    }
    
    private func dismissalToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { dismiss() }
    }
}

// MARK: - Raíz
struct ContentView: View {
    var body: some View {
        AztecaCroquisView()
            .onAppear {
                // Info.plist:
                // NSLocationWhenInUseUsageDescription = "Mostramos servicios familiares cercanos al estadio."
            }
    }
}

// MARK: - Panel lateral izquierdo: Estadios
struct StadiumsSideMenuView: View {
    var onClose: () -> Void
    var onSelect: (DataStore.Stadium) -> Void

    private let items = DataStore.stadiums()

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("FIFA Family+")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.black.opacity(0.08))
                            .clipShape(Circle())
                    }
                    .accessibilityLabel("Cerrar")
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 10)

                Divider()

                // Lista
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(items) { s in
                            Button {
                                onSelect(s)
                                onClose()
                            } label: {
                                HStack(spacing: 12) {
                                    // Thumbnail con fallback
                                    Group {
                                        if UIImage(named: s.imageName) != nil {
                                            Image(s.imageName)
                                                .resizable()
                                                .scaledToFill()
                                        } else {
                                            ZStack {
                                                Color.gray.opacity(0.12)
                                                Image(systemName: "photo")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                    .frame(width: 88, height: 66)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(s.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                        Text(s.city)
                                            .font(.system(size: 13))
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(.gray)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                )
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(s.name), \(s.city)")
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 24)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View { ContentView() }
}
