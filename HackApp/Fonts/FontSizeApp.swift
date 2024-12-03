import Foundation

/// Enum que define los tamaños de fuente utilizados en la aplicación.
///
/// Los valores son de tipo `CGFloat` y corresponden a tamaños de texto estándar para diferentes elementos UI.
///
/// **Casos:**
/// - `largeTitle`: 64 pts, para títulos grandes.
/// - `title`: 38 pts, para títulos.
/// - `subtitle`: 34 pts, para subtítulos.
/// - `heading`: 30 pts, para encabezados secundarios.
/// - `largeButtonText`: 52 pts, para botones grandes.
/// - `buttonText`: 26 pts, para botones estándar.
/// - `label`: 24 pts, para etiquetas.
/// - `bigText`: 22 pts, para texto destacado.
/// - `text`: 20 pts, para texto regular.
/// - `captions`: 18 pts, para subtítulos pequeños.

enum FontSizeApp: CGFloat {
    case largeTitle = 64
    case title = 38
    case subtitle = 34
    case heading = 30
    case largeButtonText = 52
    case buttonText = 26
    case label = 24
    case bigText = 22
    case text = 20
    case captions = 18
}
