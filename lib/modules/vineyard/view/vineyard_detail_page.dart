import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/vineyard/bloc/vineyard_bloc.dart';
import 'package:kevin/services/app_functions.dart';

import '../../../const/app_units.dart';
import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../../../ui/widgets/app_loading_indicator.dart';
import '../../../ui/widgets/app_scaffold.dart';
import '../../../ui/widgets/app_toast_messages.dart';
import '../../../ui/widgets/buttons/app_icon_button.dart';
import '../../../ui/widgets/texts/app_text_field.dart';
import '../model/vineyard_model.dart';

class VineyardDetailPage extends StatefulWidget {
  final VineyardModel? vineyardModel;
  const VineyardDetailPage({
    Key? key,
    this.vineyardModel,
  }) : super(key: key);

  @override
  State<VineyardDetailPage> createState() => _VineyardDetailPageState();
}

class _VineyardDetailPageState extends State<VineyardDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  late VineyardModel? vineyardModel;

  @override
  void initState() {
    vineyardModel = widget.vineyardModel;
    if (vineyardModel != null) {
      _titleController.text = vineyardModel!.title;
      _areaController.text = parseDouble(vineyardModel!.area);
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _bodyWidget(),
      appBar: AppBar(
        title: Text(vineyardModel != null ? vineyardModel!.title : AppLocalizations.of(context)!.createVineyard),
        actions: [
          BlocConsumer<VineyardBloc, VineyardState>(
            listener: (context, state) {
              if (state is VineyardSuccessState) {
                setState(() {
                  vineyardModel != null
                      ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                      : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
                });
                Navigator.pop(context);
              } else if (state is VineyardFailureState) {
                AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
              }
            },
            builder: (context, state) {
              if (state is VineyardLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppIconButton(
                  iconButtonType: IconButtonType.save,
                  onPress: () {
                    if (_formKey.currentState!.validate()) {
                      final vineyard = VineyardModel(
                        id: vineyardModel != null ? vineyardModel!.id : null,
                        projectId: appPreferences.getUserProject().project.id,
                        title: _titleController.text.trim(),
                        area: double.parse(_areaController.text),
                        created: DateTime.now(),
                        updated: vineyardModel != null ? DateTime.now() : null,
                      );

                      vineyardModel != null
                          ? BlocProvider.of<VineyardBloc>(context).add(UpdateVineyardEvent(vineyard))
                          : BlocProvider.of<VineyardBloc>(context).add(CreateVineyardEvent(vineyard));
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _form(context),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTextField(
            controller: _titleController,
            label: AppLocalizations.of(context)!.title,
            isRequired: true,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _areaController,
            label: AppLocalizations.of(context)!.area,
            inputType: InputType.double,
            unit: AppUnits.squareMeter,
          ),
        ],
      ),
    );
  }
}
