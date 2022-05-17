import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_brunner_app/src/page/Home/menu_widget.dart';
import 'package:new_brunner_app/src/page/Mantenimiento/Mantenimiento%20Correctivo/Correctivo/mant_correctivo.dart';
import 'package:new_brunner_app/src/widget/option_widget.dart';

class MantenimientoCorrectivo extends StatelessWidget {
  const MantenimientoCorrectivo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Mantenimiento correcctivo',
          style: TextStyle(
            color: Colors.white,
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: const MenuWidget(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) {
              //       return const MantCorrectivo();
              //     },
              //   ),
              // );
            },
            child: const OptionWidget(
              titulo: 'Mantenimiento Correctivo',
              descripcion: '',
              icon: Icons.car_repair_outlined,
              color: Color(0XFF02caed),
            ),
          ),
          SizedBox(height: ScreenUtil().setWidth(30)),
          InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) {
              //       return const ConsultaInformacion();
              //     },
              //   ),
              // );
            },
            child: const OptionWidget(
              titulo: 'Orden Habilitación Correctiva',
              descripcion: '',
              icon: Icons.check_circle,
              color: Color(0XFF67a805),
            ),
          ),
        ],
      ),
    );
  }
}
