class CuponesGenericos {
  final int cuponesGenericoId;
  final String fechaExpiracion;
  final int cuponesUsados;
  final int cuponesVisitados;
  final int porcentajeDescuento;
  final int numeroPorPersona;
  final String descripcion;
  final int empresaId;

  CuponesGenericos.fromJson(
    Map<String, dynamic> json,
  )   : cuponesGenericoId = json['cuponGeneridoId'] ?? 0,
        fechaExpiracion = json['fechaExpiracion'] ?? "",
        cuponesUsados = json['cuponesUsados'] ?? 0,
        cuponesVisitados = json['cuponesVisitados'] ?? 0,
        porcentajeDescuento = json['porcentajeDescuento'] ?? 0,
        numeroPorPersona = json['numeroPorPersona'] ?? 0,
        descripcion = json['descripcion'] ?? "",
        empresaId = json['empresaId'] ?? 0;
}
