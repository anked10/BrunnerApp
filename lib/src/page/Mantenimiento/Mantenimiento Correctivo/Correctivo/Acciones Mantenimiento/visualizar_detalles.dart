import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/bloc/provider_bloc.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/inspeccion_vehiculo_detalle_model.dart';
import 'package:new_brunner_app/src/model/Mantenimiento/mantenimiento_correctivo_model.dart';
import 'package:new_brunner_app/src/util/utils.dart';
import 'package:new_brunner_app/src/widget/show_loading.dart';

class VisualizarDetalles extends StatelessWidget {
  const VisualizarDetalles({Key? key, required this.detalle}) : super(key: key);
  final InspeccionVehiculoDetalleModel detalle;

  @override
  Widget build(BuildContext context) {
    final detalleBloc = ProviderBloc.mantenimientoCorrectivo(context);
    detalleBloc.getDetalleInspeccionManttCorrectivoById(detalle.idInspeccionDetalle.toString(), detalle.tipoUnidad.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historial Mantenimiento Correctivo',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(15),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<InspeccionVehiculoDetalleModel>>(
        stream: detalleBloc.detalleManttCorrectivoStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              var dato = snapshot.data![0];
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                        vertical: ScreenUtil().setHeight(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fileData('Check List', 'N° ${dato.nroCheckList}', 15, 15, FontWeight.w400, FontWeight.w500, TextAlign.start),
                          Text(
                            '${obtenerFecha(dato.fechaInspeccion.toString())} ${dato.horaInspeccion}',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(11),
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    placa(
                      dato.plavaVehiculo.toString(),
                      Icons.bus_alert,
                      (dato.estadoInspeccionDetalle == '2')
                          ? Colors.orangeAccent
                          : (dato.estadoInspeccionDetalle == '3')
                              ? Colors.redAccent
                              : const Color(0XFF09AD92),
                    ),
                    const Divider(),
                    Text(
                      '${dato.descripcionCategoria}',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(14)),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    fileData('Descripción', '${dato.descripcionItem}', 14, 15, FontWeight.w400, FontWeight.w500, TextAlign.center),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(16),
                      ),
                      child:
                          fileData('Observación', '${dato.observacionInspeccionDetalle}', 14, 15, FontWeight.w500, FontWeight.w400, TextAlign.center),
                    ),
                    const Divider(),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    Text(
                      'HISTORIAL',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil().setSp(16),
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(8)),
                    options(context, 'Diagnóstico', dato.mantCorrectivos!, 1),
                    options(context, 'Acciones Correctivas', dato.mantCorrectivos!, 2),
                    options(context, 'Recomendaciones', dato.mantCorrectivos!, 3),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Sin datos...'),
              );
            }
          } else {
            return ShowLoadding(
              active: true,
              h: double.infinity,
              w: double.infinity,
              fondo: Colors.black.withOpacity(.1),
              colorText: Colors.black,
            );
          }
        },
      ),
    );
  }

  Widget options(BuildContext context, String titulo, List<MantenimientoCorrectivoModel> detail, int tipoOption) {
    List<MantenimientoCorrectivoModel> showList = [];
    for (var i = 0; i < detail.length; i++) {
      switch (tipoOption) {
        case 1:
          if (detail[i].diagnostico != null) {
            showList.add(detail[i]);
          }

          break;
        case 2:
          if (detail[i].conclusion != null) {
            showList.add(detail[i]);
          }

          break;
        case 3:
          if (detail[i].recomendacion != null) {
            showList.add(detail[i]);
          }

          break;
        default:
      }
    }
    return (showList.isNotEmpty)
        ? ExpansionTile(
            backgroundColor: Colors.white,
            onExpansionChanged: (valor) {},
            maintainState: true,
            title: Text(
              titulo,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: ScreenUtil().setSp(14),
                fontWeight: FontWeight.w500,
              ),
            ),
            children: showList.map((item) => detalleOption(item, tipoOption)).toList(),
          )
        : Container();
  }

  Widget detalleOption(MantenimientoCorrectivoModel data, int tipo) {
    return Container(
      child: Stack(children: [
        Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (detalle.estadoFinalInspeccionDetalle == '0') ? Colors.redAccent.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.transparent.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [Text(data.responsable.toString())],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: ScreenUtil().setWidth(150),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.blueGrey)),
            child: Center(
              child: Text(
                obtenerFechaHora(data.dateTimeMantenimiento.toString()),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: ScreenUtil().setSp(12),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
