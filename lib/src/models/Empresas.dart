class Empresas {
  final int empresaId;
  final String url;

  Empresas.fromJson(
    Map<String, dynamic> json,
  )   : empresaId = json['EmpresaId'] ?? 0,
        url = json['ImagenEmpresa'] ?? "";
}
