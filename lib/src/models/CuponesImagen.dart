class CuponesImagen {
  final int cuponesImagenId;
  final String fechaExpiracion;
  final int cuponesUsados;
  final int cuponesVisitados;
  final String descripcion;
  final String imagen;
  final int empresaId;
  final String domain;

  CuponesImagen.fromJson(
    Map<String, dynamic> json,
  )   : cuponesImagenId = json['cuponImagenId'] ?? 0,
        fechaExpiracion = json['fechaExpiracion'] ?? "",
        cuponesUsados = json['cuponesUsados'] ?? 0,
        cuponesVisitados = json['cuponesVisitados'] ?? 0,
        descripcion = json['descripcion'] ?? "",
        imagen = json['imagen'] ?? "",
        empresaId = json['empresaId'] ?? 0,
        domain = json['domain'] ?? "";
}
