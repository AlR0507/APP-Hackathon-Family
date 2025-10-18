import SwiftUI
import MapKit
import UIKit   // para usar UIColor.*
import CoreLocation
import Combine

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
    let id: String
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
    static let estadioBBVA = CLLocationCoordinate2D(latitude: 25.6696021,
                                                    longitude: -100.2446)
    
    static func banos() -> [DetalleUbicacion] {
        [
            .init(id: "azteca-banos-1", numero: "1", tipo: .banos, titulo: "Explanada Principal - Entrada Norte",
                  descripcion: "Baño familiar ubicado estratégicamente en la entrada principal norte.",
                  informacionAdicional: ["Nivel 1 - Planta Baja", "Cerca de Puerta 1"],
                  servicios: ["Cambiador para bebés", "Espacio amplio para carriolas"],
                  puntoCroquis: CGPoint(x: -60, y: -160),
                  coordinate: estadioAzteca),
            .init(id: "azteca-banos-2", numero: "2", tipo: .banos, titulo: "Zona Palcos Club - Área Premium",
                  descripcion: "Baño familiar exclusivo en la zona VIP.",
                  informacionAdicional: ["Nivel 2 - Palco Club", "Área VIP"],
                  servicios: ["Servicio premium", "Ambiente privado"],
                  puntoCroquis: CGPoint(x: 100, y: -70),
                  coordinate: estadioAzteca),
            .init(id: "azteca-banos-3", numero: "3", tipo: .banos, titulo: "Lateral Este - Cerca Banorte",
                  descripcion: "Ubicado en el lateral este.",
                  informacionAdicional: ["Nivel 1 - Concourse", "Lateral Este"],
                  servicios: ["Fácil acceso", "Señalización clara"],
                  puntoCroquis: CGPoint(x: 160, y: -20),
                  coordinate: estadioAzteca),
            .init(id: "azteca-banos-4", numero: "4", tipo: .banos, titulo: "Lateral Oeste - Cerca Sta Ursula",
                  descripcion: "Baño familiar en el lateral oeste.",
                  informacionAdicional: ["Nivel 1 - Concourse", "Lateral Oeste"],
                  servicios: ["Amplio espacio", "Ventilación natural"],
                  puntoCroquis: CGPoint(x: -160, y: -20),
                  coordinate: estadioAzteca),
            .init(id: "azteca-banos-5", numero: "5", tipo: .banos, titulo: "Acceso Sur - Cabecera Sur",
                  descripcion: "Ideal para familias que llegan del sur.",
                  informacionAdicional: ["Nivel 1 - Planta Baja", "Cabecera Sur"],
                  servicios: ["Entrada directa", "Fácil estacionamiento"],
                  puntoCroquis: CGPoint(x: 0, y: 160),
                  coordinate: estadioAzteca),
            .init(id: "azteca-banos-6", numero: "6", tipo: .banos, titulo: "Nivel Intermedio - Área Comida",
                  descripcion: "Ubicado cerca del área de comida.",
                  informacionAdicional: ["Nivel 1.5 - Mezzanine", "Área de Comida"],
                  servicios: ["Cerca de servicios", "Espacio tranquilo"],
                  puntoCroquis: CGPoint(x: -100, y: -70),
                  coordinate: estadioAzteca)
        ]
    }

    static func accesos() -> [DetalleUbicacion] {
        [
            .init(id: "azteca-accesos-A", numero: "A", tipo: .accesos, titulo: "Túnel Principal Norte",
                  descripcion: "Túnel principal de acceso norte.",
                  informacionAdicional: ["Túnel Principal", "Acceso Norte"],
                  servicios: ["Acceso amplio", "Iluminación completa"],
                  puntoCroquis: CGPoint(x: 0, y: -155),
                  coordinate: estadioAzteca),
            .init(id: "azteca-accesos-B", numero: "B", tipo: .accesos, titulo: "Rampa VIP - Zona Palcos",
                  descripcion: "Rampa de acceso exclusiva para zonas VIP.",
                  informacionAdicional: ["Rampa Accesible", "Área VIP"],
                  servicios: ["Para carriolas y sillas", "Inclinación suave"],
                  puntoCroquis: CGPoint(x: 110, y: -130),
                  coordinate: estadioAzteca),
            .init(id: "azteca-accesos-C", numero: "C", tipo: .accesos, titulo: "Acceso Lateral Este",
                  descripcion: "Acceso principal del lateral este.",
                  informacionAdicional: ["Acceso Principal", "Lateral Este"],
                  servicios: ["Puertas amplias", "Bien iluminado"],
                  puntoCroquis: CGPoint(x: 155, y: -40),
                  coordinate: estadioAzteca),
            .init(id: "azteca-accesos-D", numero: "D", tipo: .accesos, titulo: "Acceso Lateral Oeste",
                  descripcion: "Acceso del lateral oeste.",
                  informacionAdicional: ["Acceso Principal", "Lateral Oeste"],
                  servicios: ["Estacionamiento cercano", "Acceso rápido"],
                  puntoCroquis: CGPoint(x: -155, y: -40),
                  coordinate: estadioAzteca),
            .init(id: "azteca-accesos-E", numero: "E", tipo: .accesos, titulo: "Túnel Sur - Acceso Principal",
                  descripcion: "Túnel de acceso sur.",
                  informacionAdicional: ["Túnel Secundario", "Acceso Sur"],
                  servicios: ["Conexión rápida", "Menos congestionado"],
                  puntoCroquis: CGPoint(x: 0, y: 155),
                  coordinate: estadioAzteca),
            .init(id: "azteca-accesos-F", numero: "F", tipo: .accesos, titulo: "Rampa Intermedia",
                  descripcion: "Rampa interna que conecta diferentes niveles.",
                  informacionAdicional: ["Rampa Interna", "Área Central"],
                  servicios: ["Entre niveles", "Fácil acceso"],
                  puntoCroquis: CGPoint(x: -110, y: -130),
                  coordinate: estadioAzteca)
        ]
    }

    static func primerosAuxilios() -> [DetalleUbicacion] {
        [
            .init(id: "azteca-auxilios-M1", numero: "M1", tipo: .primerosAuxilios, titulo: "Área Médica Principal",
                  descripcion: "Punto central de atención médica.",
                  informacionAdicional: ["Enfermería Principal", "Zona Poniente"],
                  servicios: ["Personal médico", "Botiquín completo"],
                  puntoCroquis: CGPoint(x: -140, y: -30),
                  coordinate: estadioAzteca),
            .init(id: "azteca-auxilios-M2", numero: "M2", tipo: .primerosAuxilios, titulo: "Módulo Norte",
                  descripcion: "Puesto médico en el anillo norte.",
                  informacionAdicional: ["Puesto Temporal", "Anillo Norte"],
                  servicios: ["Atención básica", "Botiquín esencial"],
                  puntoCroquis: CGPoint(x: -40, y: -140),
                  coordinate: estadioAzteca),
            .init(id: "azteca-auxilios-M3", numero: "M3", tipo: .primerosAuxilios, titulo: "Módulo Sur",
                  descripcion: "Punto de apoyo médico en la zona sur.",
                  informacionAdicional: ["Puesto de Emergencia", "Zona Sur"],
                  servicios: ["Atención de emergencia", "Botiquín avanzado"],
                  puntoCroquis: CGPoint(x: -30, y: 130),
                  coordinate: estadioAzteca)
        ]
    }

    static func lactancia() -> [DetalleUbicacion] {
        [
            .init(id: "azteca-lactancia-L1", numero: "L1", tipo: .lactancia, titulo: "Sala Lactancia Principal",
                  descripcion: "Sala principal de lactancia en la explanada norte.",
                  informacionAdicional: ["Nivel 1 - Explanada", "Zona familiar"],
                  servicios: ["Sala privada", "Sillones reclinables", "Cambiadores higiénicos"],
                  puntoCroquis: CGPoint(x: -40, y: -150),
                  coordinate: estadioAzteca),
            .init(id: "azteca-lactancia-L2", numero: "L2", tipo: .lactancia, titulo: "Sala Lactancia Lateral Este",
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
    static func bbvaBanos() -> [DetalleUbicacion] {
        [
            .init(id: "bbva-banos-1", numero: "1", tipo: .banos, titulo: "Anillo Bajo Oriente",
                  descripcion: "Baño familiar en anillo bajo oriente.",
                  informacionAdicional: ["Nivel 1", "Cerca de Av. Pablo Livas"],
                  servicios: ["Cambiador", "Espacio para carriolas"],
                  puntoCroquis: CGPoint(x: 120, y: 40),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-2", numero: "2", tipo: .banos, titulo: "Anillo Bajo Poniente",
                  descripcion: "Baño familiar en anillo bajo poniente.",
                  informacionAdicional: ["Nivel 1", "Zona Poniente"],
                  servicios: ["Cabina accesible", "Señalización táctil"],
                  puntoCroquis: CGPoint(x: -120, y: 40),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-3", numero: "3", tipo: .banos, titulo: "Cabecera Norte",
                  descripcion: "Baño familiar cercano a cabecera norte.",
                  informacionAdicional: ["Nivel 1", "Zona Norte"],
                  servicios: ["Cambiador para bebés"],
                  puntoCroquis: CGPoint(x: 0, y: -138),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-4", numero: "4", tipo: .banos, titulo: "Cabecera Sur",
                  descripcion: "Baño familiar en cabecera sur.",
                  informacionAdicional: ["Nivel 1", "Zona Sur"],
                  servicios: ["Área amplia", "Buen flujo"],
                  puntoCroquis: CGPoint(x: 0, y: 148),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-5", numero: "5", tipo: .banos, titulo: "Esquina NE (Mezzanine)",
                  descripcion: "Baño familiar intermedio, esquina noreste.",
                  informacionAdicional: ["Nivel 1.5", "Entre anillos"],
                  servicios: ["Cambiador", "Lavamanos bajo"],
                  puntoCroquis: CGPoint(x: 110, y: -72),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-6", numero: "6", tipo: .banos, titulo: "Esquina NO (Mezzanine)",
                  descripcion: "Baño familiar intermedio, esquina noroeste.",
                  informacionAdicional: ["Nivel 1.5", "Entre anillos"],
                  servicios: ["Cambiador", "Área de descanso"],
                  puntoCroquis: CGPoint(x: -110, y: -72),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-7", numero: "7", tipo: .banos, titulo: "Zona Club Oriente",
                  descripcion: "Baño familiar en zona club (oriente).",
                  informacionAdicional: ["Nivel Club", "Acceso controlado"],
                  servicios: ["Servicio asistido"],
                  puntoCroquis: CGPoint(x: 95, y: 0),
                  coordinate: estadioBBVA),
            .init(id: "bbva-banos-8", numero: "8", tipo: .banos, titulo: "Zona Club Poniente",
                  descripcion: "Baño familiar en zona club (poniente).",
                  informacionAdicional: ["Nivel Club", "Acceso controlado"],
                  servicios: ["Servicio asistido"],
                  puntoCroquis: CGPoint(x: -95, y: 0),
                  coordinate: estadioBBVA)
        ]
    }

    static func bbvaAccesos() -> [DetalleUbicacion] {
        [
            .init(id: "bbva-accesos-A", numero: "A", tipo: .accesos, titulo: "Rampa Oriente",
                  descripcion: "Rampa con pendiente suave (oriente).",
                  informacionAdicional: ["Exterior", "Ingreso controlado"],
                  servicios: ["Sillas de ruedas", "Carriolas"],
                  puntoCroquis: CGPoint(x: 145, y: -38),
                  coordinate: estadioBBVA),
            .init(id: "bbva-accesos-B", numero: "B", tipo: .accesos, titulo: "Rampa Poniente",
                  descripcion: "Rampa accesible (poniente).",
                  informacionAdicional: ["Exterior", "Sector Poniente"],
                  servicios: ["Sillas de ruedas", "Iluminación"],
                  puntoCroquis: CGPoint(x: -145, y: -38),
                  coordinate: estadioBBVA),
            .init(id: "bbva-accesos-C", numero: "C", tipo: .accesos, titulo: "Túnel Sur Principal",
                  descripcion: "Túnel de acceso principal al sur.",
                  informacionAdicional: ["Ingreso principal", "Flujo alto"],
                  servicios: ["Señalética clara"],
                  puntoCroquis: CGPoint(x: 0, y: 156),
                  coordinate: estadioBBVA),
            .init(id: "bbva-accesos-D", numero: "D", tipo: .accesos, titulo: "Túnel Norte",
                  descripcion: "Acceso por túnel en cabecera norte.",
                  informacionAdicional: ["Ingreso secundario", "Zona Norte"],
                  servicios: ["Flujo medio"],
                  puntoCroquis: CGPoint(x: 0, y: -156),
                  coordinate: estadioBBVA),
            .init(id: "bbva-accesos-E", numero: "E", tipo: .accesos, titulo: "Puerta Lateral SE",
                  descripcion: "Acceso lateral sureste.",
                  informacionAdicional: ["Control de boletos", "Cerca de estacionamiento"],
                  servicios: ["Puertas anchas"],
                  puntoCroquis: CGPoint(x: 108, y: 118),
                  coordinate: estadioBBVA),
            .init(id: "bbva-accesos-F", numero: "F", tipo: .accesos, titulo: "Puerta Lateral SO",
                  descripcion: "Acceso lateral suroeste.",
                  informacionAdicional: ["Control de boletos", "Cerca de transporte"],
                  servicios: ["Puertas anchas"],
                  puntoCroquis: CGPoint(x: -108, y: 118),
                  coordinate: estadioBBVA)
        ]
    }

    static func bbvaPrimerosAuxilios() -> [DetalleUbicacion] {
        [
            .init(id: "bbva-auxilios-M1", numero: "M1", tipo: .primerosAuxilios, titulo: "Módulo Médico Sur",
                  descripcion: "Punto de atención médica cabecera sur.",
                  informacionAdicional: ["Enfermería", "Zona Sur"],
                  servicios: ["Atención básica", "DEA"],
                  puntoCroquis: CGPoint(x: -40, y: 120),
                  coordinate: estadioBBVA),
            .init(id: "bbva-auxilios-M2", numero: "M2", tipo: .primerosAuxilios, titulo: "Módulo Médico Oriente",
                  descripcion: "Apoyo médico lado oriente.",
                  informacionAdicional: ["Puesto temporal", "Lado Oriente"],
                  servicios: ["Primeros auxilios"],
                  puntoCroquis: CGPoint(x: 112, y: -8),
                  coordinate: estadioBBVA),
            .init(id: "bbva-auxilios-M3", numero: "M3", tipo: .primerosAuxilios, titulo: "Módulo Médico Poniente",
                  descripcion: "Apoyo médico lado poniente.",
                  informacionAdicional: ["Puesto temporal", "Lado Poniente"],
                  servicios: ["Primeros auxilios"],
                  puntoCroquis: CGPoint(x: -112, y: -8),
                  coordinate: estadioBBVA),
            .init(id: "bbva-auxilios-M4", numero: "M4", tipo: .primerosAuxilios, titulo: "Punto de Respuesta Norte",
                  descripcion: "Equipo de respuesta rápida (norte).",
                  informacionAdicional: ["Zona Norte", "Patrullaje interno"],
                  servicios: ["Radio enlace"],
                  puntoCroquis: CGPoint(x: 28, y: -110),
                  coordinate: estadioBBVA)
        ]
    }

    static func bbvaLactancia() -> [DetalleUbicacion] {
        [
            .init(id: "bbva-lactancia-L1", numero: "L1", tipo: .lactancia, titulo: "Sala Lactancia Oriente",
                  descripcion: "Sala tranquila para lactancia lado oriente.",
                  informacionAdicional: ["Nivel 1", "Cercana a servicios"],
                  servicios: ["Cabinas", "Cambiadores", "Sillones"],
                  puntoCroquis: CGPoint(x: 92, y: 100),
                  coordinate: estadioBBVA),
            .init(id: "bbva-lactancia-L2", numero: "L2", tipo: .lactancia, titulo: "Sala Lactancia Poniente",
                  descripcion: "Zona de lactancia lado poniente.",
                  informacionAdicional: ["Nivel 1", "Sector Poniente"],
                  servicios: ["Sillones", "Área higiénica"],
                  puntoCroquis: CGPoint(x: -92, y: 100),
                  coordinate: estadioBBVA),
            .init(id: "bbva-lactancia-L3", numero: "L3", tipo: .lactancia, titulo: "Punto Calma Sur",
                  descripcion: "Espacio familiar para lactancia y descanso.",
                  informacionAdicional: ["Cabecera Sur", "Ambiente silencioso"],
                  servicios: ["Área privada", "Tomas eléctricas"],
                  puntoCroquis: CGPoint(x: 0, y: 128),
                  coordinate: estadioBBVA)
        ]
    }

    static func ubicacionesBBVA(for categoria: Categoria) -> [DetalleUbicacion] {
        switch categoria {
        case .banos:            return bbvaBanos()
        case .accesos:          return bbvaAccesos()
        case .primerosAuxilios: return bbvaPrimerosAuxilios()
        case .lactancia:        return bbvaLactancia()
        case .none:             return []
        }
    }
    // ==== Modelo para listado de estadios en el panel
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
// Helper para crear coordenadas
@inline(__always)
func coord(_ lat: Double, _ lon: Double) -> CLLocationCoordinate2D {
    .init(latitude: lat, longitude: lon)
}

// ✅ Servicios fijos alrededor del Estadio BBVA (usando tus coordenadas)
let BBVA_SERVICES: [FamilyService] = [
    // Clínicas / Hospitales
    .init(name: "IMSS CLINIC 4",
          category: .clinica,
          coordinate: coord(25.6731688, -100.2614015),
          description: "C. Mariano Matamoros 300, Centro de Guadalupe, 67100",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Cruz Verde Centro de Guadalupe",
          category: .clinica,
          coordinate: coord(25.6793539, -100.2474187),
          description: "Centro de Guadalupe, 67155",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "ALFA Medical Center",
          category: .clinica,
          coordinate: coord(25.6790117, -100.2618477),
          description: "Independencia 410, Centro de Guadalupe, 67100",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Cela Hospital",
          category: .clinica,
          coordinate: coord(25.6566042, -100.2620486),
          description: "P.º de las Américas 1881, Contry Sol, 67174",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Cruz Roja Guadalupe",
          category: .clinica,
          coordinate: coord(25.6621216, -100.2383595),
          description: "Las Villas, 67175",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    // Farmacias
    .init(name: "Farmacias Benavides (Eloy Cavazos)",
          category: .farmacia,
          coordinate: coord(25.6621861, -100.2410861),
          description: "Av Eloy Cavazos, Privadas del Contry, 67170",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Farmacia Guadalajara (Quetzales 2902)",
          category: .farmacia,
          coordinate: coord(25.6622934, -100.2419538),
          description: "Quetzales 2902, Privadas del Contry, 67175",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Farmacia Guadalajara (Av. Las Torres)",
          category: .farmacia,
          coordinate: coord(25.6721163, -100.2495679),
          description: "Av. Las Torres 627a, 67140",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Farmacia Guadalajara (Zona La Silla)",
          category: .farmacia,
          coordinate: coord(25.6699081, -100.2365644),
          description: "Cercano al Mirador de la Silla",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    // Supermercados / Tiendas
    .init(name: "Walmart La Pastora",
          category: .supermercado,
          coordinate: coord(25.6638862, -100.2419628),
          description: "Av Eloy Cavazos 2051, 67170",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Abarrotes Venus",
          category: .supermercado,
          coordinate: coord(25.6744653, -100.2528423),
          description: "Lic. Sebastián Lerdo de Tejada 102, 67144",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Tiendas Six (La Quinta)",
          category: .supermercado,
          coordinate: coord(25.6649314, -100.2428664),
          description: "La Quinta 2402, 67170",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Super Sale La Pastora",
          category: .supermercado,
          coordinate: coord(25.6597258, -100.2549650),
          description: "C. José Peón y Contreras, 67176",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Soriana Híper La Pastora",
          category: .supermercado,
          coordinate: coord(25.6617050, -100.2602078),
          description: "Av Eloy Cavazos 2000, 67174",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Bodega Aurrera Express (Polanco)",
          category: .supermercado,
          coordinate: coord(25.6719561, -100.2585779),
          description: "Gral Ignacio Zaragoza 500, 67100",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "MERKDON",
          category: .supermercado,
          coordinate: coord(25.6795243, -100.2491445),
          description: "Calle Benito Juárez 802, Centro, 67100",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    // Parques / Niños
    .init(name: "Parque Zoológico La Pastora",
          category: .parque,
          coordinate: coord(25.6657175, -100.2482422),
          description: "Av Eloy Cavazos, Jardines de La Pastora, 67140",
          amenities: ["Zoológico"], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Agua Monterrey Park",
          category: .parque,
          coordinate: coord(25.6644383, -100.2505992),
          description: "Vereda Bosque La Pastora, 67174",
          amenities: ["Juegos de agua"], hours: "Ver en Apple Maps", phone: nil),

    .init(name: "Parque Mirador de la Silla",
          category: .parque,
          coordinate: coord(25.6682132, -100.2345679),
          description: "Mirador de La Silla 1er Sector, 67176",
          amenities: [], hours: "Ver en Apple Maps", phone: nil),

    // Lactancia / Bebés (fuera del estadio)
    .init(name: "Plaza Principal de Guadalupe (Zona de lactancia)",
          category: .bebes,
          coordinate: coord(25.6770972, -100.2591387),
          description: "Centro de Guadalupe, 67100",
          amenities: ["Zona de lactancia"], hours: "Ver en Apple Maps", phone: nil),
]
// ======= NUEVO: Lista de direcciones reales + Geocoder =======
struct AddressItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    let category: ServiceCategory
}

let INPUT_ADDRESSES: [AddressItem] = [
    .init(name: "Coppel Tlalpan Azteca",
          address: "Calzada De Tlalpan 3375, Coyoacán, CDMX",
          category: .supermercado),
    .init(name: "Novag Infancia",
          address: "Calzada de Tlalpan 3417, Santa Úrsula Coapa, CDMX",
          category: .farmacia),
    .init(name: "Hospital General Dr. Manuel Gea González",
          address: "Calz. de Tlalpan 4800, Belisario Domínguez Secc 16, Tlalpan, 14080 CDMX",
          category: .clinica),
    .init(name: "Shriners Children's México",
          address: "Av. del Imán 257, Pedregal de Sta Úrsula, Coyoacán, 04600 CDMX",
          category: .clinica),
    .init(name: "Parque Ecológico Santa Úrsula",
          address: "San Benito 347, Pedregal de Sta Úrsula, Coyoacán, 04600 CDMX",
          category: .parque),
    .init(name: "Tianguis Santa Úrsula",
          address: "San Hermilo, Pedregal de Sta Úrsula, Coyoacán, 04600 CDMX",
          category: .supermercado),
    .init(name: "Mercado La Paz",
          address: "Calle Madero y Congreso, Guadalupe Victoria 97, Tlalpan Centro I, 14000 CDMX",
          category: .supermercado),
    .init(name: "Hospital Merlos",
          address: "Circuito Estadio Azteca 179, El Caracol, Coyoacán, 04739 CDMX",
          category: .clinica),
    .init(name: "Gran Sur",
          address: "Periférico Sur 5550, Pedregal de Carrasco, Coyoacán, 04700 CDMX",
          category: .supermercado),
    .init(name: "Hospital Tlalpan",
          address: "Prol. Bordo 24, Villa Lázaro Cárdenas, Tlalpan, 14370 CDMX",
          category: .clinica),
    .init(name: "Parque Novias",
          address: "Luis Murillo 36, Bosques de Tetlameya, Coyoacán, 04730 CDMX",
          category: .parque),
    .init(name: "Parque Joyas",
          address: "Esmeralda s/n, Joyas del Pedregal, Coyoacán, 04660 CDMX",
          category: .parque),
    .init(name: "Médica Sur - Urgencias",
          address: "Puente de Piedra 150, Pueblo Quieto, Tlalpan, 14050 CDMX",
          category: .clinica),
    .init(name: "IMSS Clínica 7 Huipulco",
          address: "Calz. de Tlalpan 4220, Huipulco, Tlalpan, 14370 CDMX",
          category: .clinica),
    .init(name: "Farmacia GYG",
          address: "Calz. de Tlalpan 4717, Toriello Guerra, Tlalpan, 14050 CDMX",
          category: .farmacia),
    .init(name: "Farmacias del Ahorro Huipulco",
          address: "Cda. San Juan Bosco 2, Huipulco, Tlalpan, 14370 CDMX",
          category: .farmacia),
    .init(name: "Farmacia San Celso",
          address: "C. San Celso 309, Pedregal de Sta Úrsula, Coyoacán, 04600 CDMX",
          category: .farmacia),
    .init(name: "Food Market Huipulco",
          address: "Calz. Acoxpa y Calz. de Tlalpan, Huipulco, Tlalpan, 14370 CDMX",
          category: .supermercado),
]
let BBVA_INPUT_ADDRESSES: [AddressItem] = [
    // Clínicas / Hospitales / Urgencias
    .init(name: "IMSS Clínica 4",
          address: "C. Mariano Matamoros 300, Centro de Guadalupe, 67100 Guadalupe, N.L.",
          category: .clinica),
    .init(name: "Cruz Verde Centro de Guadalupe",
          address: "Sin Nombre de Col 31, 67155 Guadalupe, N.L.",
          category: .clinica),
    .init(name: "ALFA Medical Center",
          address: "Independencia 410, Centro de Guadalupe, 67100 Monterrey, N.L.",
          category: .clinica),
    .init(name: "Cela Hospital",
          address: "P.º de las Américas 1881, Contry Sol, 67174 Guadalupe, N.L.",
          category: .clinica),
    .init(name: "Cruz Roja Guadalupe",
          address: "Av. Eloy Cavazos 2424, Las Villas, 67175 Guadalupe, N.L.",
          category: .clinica),

    // Farmacias
    .init(name: "Farmacias Benavides (Eloy Cavazos)",
          address: "Av. Eloy Cavazos entre AV. QUETZALES Y ANACLETO ZAPATA, Privadas del Contry, 67170 Guadalupe, N.L.",
          category: .farmacia),
    .init(name: "Farmacia Guadalajara (Quetzales)",
          address: "Quetzales 2902, Privadas del Contry, 67175 Guadalupe, N.L.",
          category: .farmacia),
    .init(name: "Farmacia Guadalajara (Av. Las Torres)",
          address: "Av. Las Torres 627a-L, Sin Nombre de Col 33, 67140 Guadalupe, N.L.",
          category: .farmacia),

    // Supermercados y abarrotes
    .init(name: "Walmart",
          address: "Av. Eloy Cavazos 2051, Valles de Guadalupe, 67170 Guadalupe, N.L.",
          category: .supermercado),
    .init(name: "Soriana (Eloy Cavazos)",
          address: "Av. Eloy Cavazos 2000, Contry Sol 6to Sector, 67174 Guadalupe, N.L.",
          category: .supermercado),
    .init(name: "Bodega Aurrera Express (Fracc. Polanco)",
          address: "Gral. Ignacio Zaragoza 500, Centro, 67100 Guadalupe, N.L.",
          category: .supermercado),
    .init(name: "Abarrotes Venus",
          address: "Lic. Sebastián Lerdo de Tejada 102, Venus, 67144 Guadalupe, N.L.",
          category: .supermercado),
    .init(name: "Tiendas Six (La Quinta)",
          address: "La Quinta 2402, La Quinta, 67170 Guadalupe, N.L.",
          category: .supermercado),
    .init(name: "Super Sale La Pastora",
          address: "C. José Peón y Contreras, Bosques de La Pastora 1er Sector, 67176 Guadalupe, N.L.",
          category: .supermercado),
    .init(name: "MERKDON",
          address: "Calle Benito Juárez 802, Centro, 67100 Guadalupe, N.L.",
          category: .supermercado),

    // Parques / Recreación
    .init(name: "Parque Zoológico La Pastora",
          address: "Av. Eloy Cavazos, Jardines de La Pastora, 67140 Guadalupe, N.L.",
          category: .parque),
    .init(name: "Agua Monterrey Park",
          address: "Vereda Bosque La Pastora, Sin Nombre de Col 33, 67174 Guadalupe, N.L.",
          category: .parque),

    // Lactancia (fuera del estadio → lo marcamos como Bebés)
    .init(name: "Plaza Principal de Guadalupe (Zona de lactancia)",
          address: "Centro de Guadalupe, 67100 Guadalupe, N.L.",
          category: .bebes)
]

@MainActor
final class BatchGeocoder: ObservableObject {
    @Published var services: [FamilyService] = []
    private let geocoder = CLGeocoder()

    func resolveAll(_ input: [AddressItem]) {
        Task {
            var results: [FamilyService] = []

            for item in input {
                // Evitar duplicados por nombre
                if results.contains(where: { $0.name.caseInsensitiveCompare(item.name) == .orderedSame }) {
                    continue
                }
                do {
                    let placemarks = try await geocoder.geocodeAddressString(item.address)
                    if let pm = placemarks.first, let loc = pm.location {
                        let coord = loc.coordinate
                        let fs = FamilyService(
                            name: item.name,
                            category: item.category,
                            coordinate: coord,
                            description: item.address,
                            amenities: [],
                            hours: "Ver en Apple Maps",
                            phone: nil
                        )
                        // Evitar duplicados por cercanía (≈30m)
                        let nearDup = results.contains { existing in
                            let dLat = existing.coordinate.latitude  - coord.latitude
                            let dLon = existing.coordinate.longitude - coord.longitude
                            let meters = hypot(dLat, dLon) * 111_000.0
                            return meters < 30.0
                        }
                        if !nearDup { results.append(fs) }
                    }
                } catch {
                    // si falla una dirección, continuamos
                    continue
                }
            }
            self.services = results
        }
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

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 14) {

                // === BARRA SUPERIOR AMARILLA ===
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color(red: 1.0, green: 0.82, blue: 0.18),
                                Color(red: 1.0, green: 0.70, blue: 0.10)
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(height: 58)
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 3)

                    HStack {
                        Text("FIFA Family+")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                        Spacer()
                        Circle().fill(Color.clear).frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                // === TÍTULO ===
                VStack(spacing: 2) {
                    Text("Estadio Azteca")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                }

                // === BOTONES DE CATEGORÍAS CENTRADOS ===
                HStack(spacing: 24) {
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
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

                // === TARJETA CON MARCO ROJO ===
                GeometryReader { geo in
                    let cardPadding: CGFloat = 18
                    let cardWidth = geo.size.width - (cardPadding * 2)

                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.red, lineWidth: 6)
                            .background(Color.white.cornerRadius(24))
                            .shadow(color: .black.opacity(0.15), radius: 10, y: 4)

                        VStack(spacing: 0) {
                            ZStack {
                                let ancho: CGFloat = 350
                                let alto: CGFloat  = 400

                                Image("EstadioAzteca")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: ancho, height: alto)
                                    .clipped()
                                    .cornerRadius(18)
                                    .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
                                    .padding(.top, 16)

                                ForEach(DataStore.ubicaciones(for: categoriaSeleccionada)) { u in
                                    PinByTipo(tipo: u.tipo, numero: u.numero)
                                        .offset(x: u.puntoCroquis.x, y: u.puntoCroquis.y)
                                        .onTapGesture { detalleSeleccionado = u }
                                }
                            }
                            .padding(.bottom, 18)
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(width: cardWidth, height: min(cardWidth * 1.1, 560))
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                }
                .frame(height: 540)

                // === TEXTO DE INSTRUCCIÓN ===
                VStack(spacing: 6) {
                    Text(instructionText(for: categoriaSeleccionada))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    Text("📍 Las ubicaciones mostradas son aproximadas")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
                .background(Color(red: 1.0, green: 0.85, blue: 0.2).opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 16)

                Spacer(minLength: 10)
            }
        }
        .sheet(item: $detalleSeleccionado) { DetalleUbicacionSheetView(detalle: $0) }
        .fullScreenCover(isPresented: $mostrarMapaExterior) {
            MapaExteriorView()
        }

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
// MARK: - Croquis interno BBVA (imagen grande, nítida y pines escalados)
struct BBVACroquisView: View {
    @State private var categoriaSeleccionada: Categoria = .none
    @State private var detalleSeleccionado: DetalleUbicacion? = nil
    @Environment(\.dismiss) private var dismiss

    private let baseW: CGFloat = 350
    private let baseH: CGFloat = 400

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 14) {

                // === BARRA SUPERIOR AMARILLA ===
                ZStack {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(
                            LinearGradient(colors: [
                                Color(red: 1.0, green: 0.82, blue: 0.18),
                                Color(red: 1.0, green: 0.70, blue: 0.10)
                            ], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(height: 58)
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 3)

                    HStack {
                        Text("FIFA Family+")
                            .font(.system(size: 18, weight: .heavy))
                            .foregroundColor(.white)
                        Spacer()
                        Circle().fill(Color.clear).frame(width: 40, height: 40)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                // === TÍTULO ===
                VStack(spacing: 2) {
                    Text("Estadio BBVA")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.black)
                }

                // === BOTONES DE CATEGORÍAS CENTRADOS ===
                HStack(spacing: 24) {
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
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)

                // === TARJETA CON MARCO ROJO ===
                GeometryReader { geo in
                    let cardPadding: CGFloat = 18
                    let cardWidth = geo.size.width - (cardPadding * 2)

                    ZStack {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color.red, lineWidth: 6)
                            .background(Color.white.cornerRadius(24))
                            .shadow(color: .black.opacity(0.15), radius: 10, y: 4)

                        VStack(spacing: 0) {
                            ZStack {
                                let uiImg = UIImage(named: "BBVAEstadiooo")
                                let aspect = max(0.01, (uiImg?.size.width ?? 16) / (uiImg?.size.height ?? 9))
                                let ancho: CGFloat = 350
                                let alto: CGFloat  = ancho / aspect
                                let scaleX = ancho / baseW
                                let scaleY = alto / baseH

                                Image("BBVAEstadiooo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: ancho, height: alto)
                                    .cornerRadius(18)
                                    .shadow(color: .black.opacity(0.12), radius: 6, y: 2)
                                    .padding(.top, 16)

                                ForEach(DataStore.ubicacionesBBVA(for: categoriaSeleccionada)) { u in
                                    PinByTipo(tipo: u.tipo, numero: u.numero)
                                        .offset(x: u.puntoCroquis.x * scaleX,
                                                y: u.puntoCroquis.y * scaleY)
                                        .onTapGesture { detalleSeleccionado = u }
                                }
                            }
                            .padding(.bottom, 18)
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(width: cardWidth, height: min(cardWidth * 1.1, 560))
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                }
                .frame(height: 540)

                // === TEXTO DE INSTRUCCIÓN ===
                VStack(spacing: 6) {
                    Text(instructionText(for: categoriaSeleccionada))
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.black)
                    Text("📍 Las ubicaciones mostradas son aproximadas")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
                .background(Color(red: 1.0, green: 0.85, blue: 0.2).opacity(0.25))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .padding(.horizontal, 16)

                Spacer(minLength: 10)
            }
        }
        .sheet(item: $detalleSeleccionado) { DetalleUbicacionSheetView(detalle: $0) }
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
    let id: String
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
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(title))
        .accessibilityHint(Text("Toca para abrir el croquis"))
        .accessibilityAddTraits(.isButton)
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
            Triangle().fill(category.color).frame(width: 8, height: 10).offset(y: -1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(category.title))
        .accessibilityHint(Text("Toca para ver detalles"))
        .accessibilityAddTraits(.isButton)
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

// MARK: - Vista principal del mapa (pines geocodificados)

enum CroquisActivo: Identifiable {
    case azteca
    case bbva
    
    var id: String {
        switch self {
        case .azteca: return "azteca"
        case .bbva: return "bbva"
        }
    }
}

struct MapaExteriorView: View {
    @Environment(\.dismiss) private var dismiss
    
    // === Regiones separadas por estadio ===
    @State private var regionAzteca = MKCoordinateRegion(
        center: DataStore.estadioAzteca,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var regionBBVA = MKCoordinateRegion(
        center: DataStore.estadioBBVA,
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var currentRegionIsBBVA = false
    @State private var croquisActivo: CroquisActivo? = nil
    
    // Navegación / UI
    @State private var mostrarMenuLateral = false
    @State private var mostrarPanelDerecho = false
    @State private var navigateToHome = false
    @State private var selectedService: FamilyService? = nil

    // Geocoder dinámico
    @StateObject private var geocoder = BatchGeocoder()
    @State private var dynamicServices: [FamilyService] = []
    
    private var points: [MapPoint] {
        let azteca = MapPoint.estadio(
            AztecaPlace(id: "azteca", title: "Estadio Azteca", coordinate: DataStore.estadioAzteca)
        )
        let bbva = MapPoint.estadio(
            AztecaPlace(id: "bbva", title: "Estadio BBVA", coordinate: DataStore.estadioBBVA)
        )
        let fixedBBVA = BBVA_SERVICES.map { MapPoint.servicio($0) }
        let servicios = dynamicServices.map { MapPoint.servicio($0) }
        return [azteca, bbva] + fixedBBVA + servicios
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    // === 1️⃣ MAPA PRINCIPAL ===
                    Map(
                        coordinateRegion: currentRegionIsBBVA ? $regionBBVA : $regionAzteca,
                        annotationItems: points
                    ) { point in
                        MapAnnotation(coordinate: point.coordinate) {
                            ZStack {
                                Circle().fill(Color.clear).frame(width: 1, height: 1)
                                switch point {
                                case .estadio(let place):
                                    EstadioAnnotationView(title: place.title)
                                        .allowsHitTesting(true)
                                        .onTapGesture {
                                            if place.title == "Estadio Azteca" {
                                                currentRegionIsBBVA = false
                                                withAnimation(.easeInOut(duration: 0.8)) {
                                                    regionAzteca.center = DataStore.estadioAzteca
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                    croquisActivo = .azteca
                                                }
                                            } else {
                                                currentRegionIsBBVA = true
                                                withAnimation(.easeInOut(duration: 0.8)) {
                                                    regionBBVA = MKCoordinateRegion(
                                                        center: DataStore.estadioBBVA,
                                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                                    )
                                                }
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                                    croquisActivo = .bbva
                                                }
                                            }
                                        }
                                case .servicio(let service):
                                    ServicePinView(category: service.category)
                                        .allowsHitTesting(true)
                                        .onTapGesture { selectedService = service }
                                }
                            }
                        }
                    }
                    .ignoresSafeArea()
                    
                    // === 2️⃣ HEADER SUPERIOR ===
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
                    
                    // === 3️⃣ PANEL LATERAL IZQUIERDO ===
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
                                        if stadium.id == "azteca" {
                                            currentRegionIsBBVA = false
                                            regionAzteca.center = stadium.coordinate
                                        } else {
                                            currentRegionIsBBVA = true
                                            regionBBVA.center = stadium.coordinate
                                        }
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
                    
                    // === 4️⃣ PANEL LATERAL DERECHO ===
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
                            
                            ServiciosCercanosSidePanel(
                                isPresented: $mostrarPanelDerecho,
                                servicios: dynamicServices
                            )
                            .frame(width: UIScreen.main.bounds.width * 0.85)
                            .transition(.move(edge: .trailing))
                        }
                        .ignoresSafeArea()
                        .zIndex(2)
                    }

                    // === 5️⃣ BOTTOM BAR ===
                    BottomPillBar(
                        onGrid: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                mostrarMenuLateral = true
                            }
                        },
                        onHome: {
                            withAnimation { navigateToHome = true }
                        },
                        onStore: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                mostrarPanelDerecho = true
                            }
                        }
                    )
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)
                    
                    NavigationLink(destination: Home().navigationBarBackButtonHidden(true),
                                   isActive: $navigateToHome) {
                        EmptyView()
                    }
                    
                    .sheet(item: $selectedService) { service in
                        FamilyServiceSheet(service: service)
                    }
                    .onAppear {
                        geocoder.resolveAll(BBVA_INPUT_ADDRESSES + INPUT_ADDRESSES)
                    }
                    .onReceive(geocoder.$services) { dynamicServices = $0 }
                }
            }
            
            // === 🧱 Capa de presentación única para croquis ===
            if let activo = croquisActivo {
                ZStack {
                    Color.black.opacity(0.55)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { croquisActivo = nil }
                        }
                    
                    VStack {
                        HStack {
                            Button {
                                withAnimation { croquisActivo = nil }
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Spacer()
                        }
                        .padding(.top, 40)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        if activo == .azteca {
                            AztecaCroquisView()
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else if activo == .bbva {
                            BBVACroquisView()
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                        
                        Spacer()
                    }
                }
                .zIndex(100)
                .animation(.easeInOut, value: croquisActivo)
            }
        }
    }
}


// MARK: - Panel lateral derecho con lista de servicios
struct ServiciosCercanosSidePanel: View {
    @Binding var isPresented: Bool
    let servicios: [FamilyService]
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
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.black.opacity(0.08))
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle()) // asegura que el toque se registre
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                Divider().background(Color.black.opacity(0.15))
                
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(servicios) { service in
                            Button { selectedService = service } label: {
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


// MARK: - Sheet de Tiendas / Servicios


// MARK: - Sheet de Servicios Cercanos


// MARK: - Vista de cada servicio en la lista

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
            // Fondo
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.3, blue: 0.6),
                    Color(red: 0.15, green: 0.35, blue: 0.65)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Atrás")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.black.opacity(0.2))

                // Contenido
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {

                        // === IMAGEN HERO UNIFORME (16:9) ===
                        // Anclada al centro. Si la quieres anclada arriba: usa .alignmentGuide con .top o cambia alignment a .top.
                        ZStack(alignment: .center) {
                            Image(detalle.tipo.imagenFondo)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .accessibilityHidden(true) // imagen decorativa
                        }
                        .aspectRatio(16/9, contentMode: .fit)
                        // .frame(height: UIScreen.main.bounds.height * 0.42) // Alternativa si prefieres altura fija
                        // ================================

                        // Card blanco (bajado)
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .top, spacing: 16) {
                                VStack(alignment: .leading, spacing: 6) {
                                    // TÍTULO: encabezado accesible
                                    Text(detalle.titulo)
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accessibilityAddTraits(.isHeader)

                                    // SUBTÍTULO / categoría
                                    Text(detalle.tipo.titulo)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .accessibilityLabel("Categoría: \(detalle.tipo.titulo)")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                // Badge con número
                                ZStack {
                                    Circle()
                                        .fill(detalle.tipo.color)
                                        .frame(width: 50, height: 50)
                                        .cardShadow()
                                    Text(detalle.numero)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("Identificador \(detalle.numero)")
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 40)
                            .padding(.bottom, 16)

                            Text(detalle.descripcion)
                                .font(.system(size: 15))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 20)
                                .accessibilityLabel("Descripción. \(detalle.descripcion)")

                            Divider().padding(.horizontal, 20)

                            HStack(alignment: .top, spacing: 24) {
                                InfoListBlock(
                                    title: "UBICACIÓN",
                                    bullets: detalle.informacionAdicional,
                                    color: detalle.tipo.color
                                )
                                InfoListBlock(
                                    title: "SERVICIOS",
                                    bullets: detalle.servicios,
                                    color: detalle.tipo.color
                                )
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
                                .accessibilityLabel("Enviar reporte sobre \(detalle.titulo)")
                                .accessibilityHint("Abre el formulario para escribir un comentario")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.top, -24) // solape suave sobre la imagen
                    }
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
                                    .accessibilityAddTraits(.isHeader)
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
                            .accessibilityAddTraits(.isHeader)

                        Text(service.description)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .accessibilityLabel("Descripción. \(service.description)")
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
            // Título como encabezado accesible
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .accessibilityAddTraits(.isHeader)

            // Lista
            VStack(alignment: .leading, spacing: 10) {
                ForEach(bullets, id: \.self) { s in
                    HStack(spacing: 10) {
                        Circle().fill(color).frame(width: 5, height: 5)
                            .accessibilityHidden(true)
                        Text(s).font(.system(size: 14))
                            .accessibilityLabel(s) // dice el ítem tal cual
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityHint("Elemento de lista")
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Lista de \(title.lowercased())")
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
            // Fondo claro de la hoja
            Color(UIColor.systemBackground).ignoresSafeArea()
                .onTapGesture { focus = false }

            // Contenido scrollable: USUARIO → TEXTO → IMAGEN CHICA
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // 1) Usuario
                    HStack(spacing: 12) {
                        ZStack {
                            Circle().fill(Color(UIColor.systemGray5))
                            Image(systemName: "person.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 44, height: 44)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Usuario")
                                .font(.system(size: 15, weight: .bold))
                            Text("juan_pablo_silva")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(Color.secondary.opacity(0.15))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                    // 2) Texto (abre teclado al aparecer)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Tu comentario")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $comentario)
                                .font(.system(size: 15))
                                .frame(minHeight: 110)
                                .padding(10)
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.black.opacity(0.07), lineWidth: 1)
                                )
                                .focused($focus)
                                .accessibilityLabel("Escribe tu comentario del reporte")

                            if comentario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("Escribe aquí tu reporte…")
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .padding(.top, 16)
                                    .padding(.leading, 18)
                                    .allowsHitTesting(false)
                                    .accessibilityHidden(true) // evitar que VoiceOver lea el placeholder
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    // 3) Imagen CHICA debajo del texto (como en referencia)
                    HStack {
                        if UIImage(named: detalle.tipo.imagenFondo) != nil {
                            Image(detalle.tipo.imagenFondo)
                                .resizable()
                                .scaledToFill()
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemGray5))
                                Image(systemName: "photo")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(width: 92, height: 92)
                    .clipped()
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.06), lineWidth: 1))
                    .padding(.horizontal, 16)
                    .accessibilityHidden(true) // solo decorativa en el formulario

                    // (Opcional) quita la tarjeta "Ubicación" si no la necesitas ya
                    // Commented out para parecerse a la referencia
                    /*
                    VStack(alignment: .leading, spacing: 8) { ... }
                    */

                    // Mensaje de error si aplica
                    if let error = errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(error).font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.yellow)
                        .padding(10)
                        .background(Color.yellow.opacity(0.15))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 80) // deja aire antes del botón fijo
                }
                .padding(.bottom, 8)
            }
        }
        // 4) Botón pegado al borde inferior que sube con el teclado
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button {
                    Task { await enviarReporte() }
                } label: {
                    HStack(spacing: 8) {
                        if isSending { ProgressView().tint(.white) }
                        Text("Publicar")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background(
                        Capsule().fill(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.55, blue: 0.40),
                                         Color(red: 0.95, green: 0.45, blue: 0.35)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                    )
                }
                .accessibilityLabel("Publicar comentario")
                .accessibilityHint("Envía tu reporte a los organizadores")
                .disabled(isSending || comentario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity((isSending || comentario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.6 : 1.0)
                .disabled(isSending || comentario.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial) // como la referencia
        }
        .onAppear { focus = true } // abre el teclado
    }
    
    // MARK: - Helpers UI
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
// Un pequeño helper para oscurecer ligeramente un color (para el texto de alerta)

   

// MARK: - Raíz
struct ContentView: View {
    var body: some View {
        MapaExteriorView()
            .onAppear {
                // Info.plist:
                // NSLocationWhenInUseUsageDescription = "Mostramos servicios familiares cercanos al estadio."
            }
            .dynamicTypeSize(...DynamicTypeSize.accessibility3)
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

#Preview {
    ContentView()
}
