class Empresas {
  final String nombreEmpresa;
  final int empresaId;
  final String url;

  Empresas.fromJson(
    Map<String, dynamic> json,
  )   : empresaId = json['EmpresaId'] ?? 0,
        url = json['ImagenEmpresa'] ?? "",
        nombreEmpresa=json['Nombre']??'';
}
