import 'package:new_brunner_app/src/api/Residuo%20Solido/ejecucion_servicio_api.dart';
import 'package:new_brunner_app/src/model/Empresa/departamento_model.dart';
import 'package:new_brunner_app/src/model/Empresa/empresas_model.dart';
import 'package:new_brunner_app/src/model/Empresa/sede_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/actividades_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/clientes_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/codigos_ue_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/contactos_oe_model.dart';
import 'package:new_brunner_app/src/model/Residuos%20Solidos/Orden%20Ejecucion/lugares_oe_model.dart';
import 'package:rxdart/rxdart.dart';

class EjecucionServicioBloc {
  final _api = EjecucionServicioApi();

  final _empresasController = BehaviorSubject<List<EmpresasModel>>();
  Stream<List<EmpresasModel>> get empresasStream => _empresasController.stream;

  final _departamentosController = BehaviorSubject<List<DepartamentoModel>>();
  Stream<List<DepartamentoModel>> get departamentosStream => _departamentosController.stream;

  final _sedesController = BehaviorSubject<List<SedeModel>>();
  Stream<List<SedeModel>> get sedesStream => _sedesController.stream;

  //Controlador para mostrar que se está cargando la consulta
  final _cargandoController = BehaviorSubject<bool>();
  Stream<bool> get cargandoStream => _cargandoController.stream;

  //Streams para Generar la Orden de Ejecucion
  final _clientesController = BehaviorSubject<List<ClientesOEModel>?>();
  Stream<List<ClientesOEModel>?> get clientesStream => _clientesController.stream;

  final _clientesSearchController = BehaviorSubject<List<ClientesOEModel>>();
  Stream<List<ClientesOEModel>> get clientesSearchStream => _clientesSearchController.stream;

  final _contactosController = BehaviorSubject<List<ContactosOEModel>>();
  Stream<List<ContactosOEModel>> get contactosStream => _contactosController.stream;

  final _codigosController = BehaviorSubject<List<CodigosOEModel>>();
  Stream<List<CodigosOEModel>> get codigosStream => _codigosController.stream;

  final _lugaresController = BehaviorSubject<List<LugaresOEModel>>();
  Stream<List<LugaresOEModel>> get lugaresStream => _lugaresController.stream;

  final _actividadesController = BehaviorSubject<List<ActividadesOEModel>>();
  Stream<List<ActividadesOEModel>> get actividadesStream => _actividadesController.stream;

  dispose() {
    _empresasController.close();
    _departamentosController.close();
    _sedesController.close();
    _clientesController.close();
    _cargandoController.close();
    _contactosController.close();
    _codigosController.close();
    _lugaresController.close();
    _actividadesController.close();
    _clientesSearchController.close();
  }

  void getDataFiltro() async {
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _departamentosController.sink.add(await _api.departamentoDB.getDepartamentos());
    _sedesController.sink.add(await _api.sedeDB.getSedes());
    await _api.getFiltrosApi();
    _empresasController.sink.add(await _api.empresaDB.getEmpresas());
    _departamentosController.sink.add(await _api.departamentoDB.getDepartamentos());
    _sedesController.sink.add(await _api.sedeDB.getSedes());
  }

  void getActividadesClientes(String idEmpresa, String idDepartamento, String idSede) async {
    _clientesController.sink.add(null);
    _cargandoController.sink.add(true);
    _clientesController.sink.add(await _api.getClientesORDEJEC(idEmpresa, idDepartamento, idSede));
    _cargandoController.sink.add(false);
  }

  void getDataSelec(String idCliente) async {
    _contactosController.sink.add(await _api.contactosDB.getContactosOEByIdCliente(idCliente));
    _codigosController.sink.add(await _api.codigosDB.getCodigosOEByIdCliente(idCliente));
    _lugaresController.sink.add(await _api.lugaresDB.getLugaresOEByIdCliente(idCliente));
    _actividadesController.sink.add(await _api.actividadesDB.getActividadesOEByIdCliente(idCliente));
  }

  void sarchClientesByQuery(String query, String id) async {
    if (query.isEmpty) {
      _clientesSearchController.sink.add(await _api.clientesDB.getClientesOE(id));
    } else {
      _clientesSearchController.sink.add(await _api.clientesDB.getClientesOEByQuery(query, id));
    }
  }
}