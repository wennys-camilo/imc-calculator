import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../core/ui/themes/app_colors.dart';
import '../../core/ui/themes/app_images.dart';
import '../../core/ui/widgets/custom_app_bar_widget.dart';
import '../../core/ui/widgets/custom_drawer_widget.dart';
import '../../core/ui/widgets/input_text_widget.dart';
import '../../core/ui/widgets/rounded_button_widget.dart';
import 'imc_store.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, ImcStore> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  FocusNode focusHeight = FocusNode();
  FocusNode focusWeight = FocusNode();

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    focusHeight.dispose();
    focusWeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawerWidget(),
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Calculadora IMC',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              weightController.clear();
              heightController.clear();
              controller.resetForm();
            },
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        AppImages.person,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    InputTextWidget(
                      controller: weightController,
                      focusNode: focusWeight,
                      labelText: 'Peso (kg)',
                      hintText: 'Peso (kg)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        PesoInputFormatter()
                      ],
                      noBorder: true,
                      onChanged: (value) => controller.onChangeWeight(value),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    InputTextWidget(
                      controller: heightController,
                      labelText: 'Altura (m)',
                      keyboardType: TextInputType.number,
                      hintText: 'Altura (m)',
                      noBorder: true,
                      focusNode: focusHeight,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        AlturaInputFormatter()
                      ],
                      onChanged: (value) => controller.onChangeHeight(value),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    RoundedButtonWidget(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          focusHeight.unfocus();
                          focusWeight.unfocus();
                          controller.fetchImc();
                        }
                      },
                      child: Text(
                        'Calcular',
                        style: TextStyle(color: AppColors.white),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.degree ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          controller.imc != null
                              ? '(${controller.imc!.toStringAsFixed(2)})'
                              : '',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
