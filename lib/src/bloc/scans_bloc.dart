import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validator {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc()  {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener scans de la base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream     => _scansController.stream.transform(validatorGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validatorHttp);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.add( await DBProvider.db.getTodosScans() );
  }

  agregarScan( ScanModel scan ) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan( int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTodos () async {
    DBProvider.db.deleteAll();
    obtenerScans();
  }
}