import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/modules/wine/bloc/wine_variety_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/ui/widgets/form/app_form.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/form/app_text_field.dart';

class WineVarietyDetailPage extends StatefulWidget {
  final WineVarietyModel? wineVariety;
  const WineVarietyDetailPage({
    super.key,
    this.wineVariety,
  });

  @override
  State<WineVarietyDetailPage> createState() => _WineVarietyDetailPageState();
}

class _WineVarietyDetailPageState extends State<WineVarietyDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.wineVariety != null) {
      _titleController.text = widget.wineVariety!.title;
      _codeController.text = widget.wineVariety!.code;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: _form(context),
      appBar: _appBar(context),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(widget.wineVariety != null ? widget.wineVariety!.title : AppLocalizations.of(context)!.createWineVariety),
      actions: [
        BlocConsumer<WineVarietyBloc, WineVarietyState>(
          listener: (context, state) {
            if (state is WineVarietySuccessState) {
              widget.wineVariety != null
                  ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastState.success)
                  : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastState.success);
              Navigator.pop(context);
            } else if (state is WineVarietyFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
            }
          },
          builder: (context, state) {
            if (state is WineVarietyLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppIconButton(
                iconButtonType: IconButtonType.save,
                onPress: (() {
                  if (_formKey.currentState!.validate()) {
                    widget.wineVariety != null
                        ? BlocProvider.of<WineVarietyBloc>(context).add(
                            UpdateWineVarietyEvent(
                              wineVarietyModel: WineVarietyModel(
                                id: widget.wineVariety!.id,
                                title: _titleController.text,
                                code: _codeController.text,
                              ),
                            ),
                          )
                        : BlocProvider.of<WineVarietyBloc>(context).add(CreateWineVarietyEvent(
                            title: _titleController.text.trim(),
                            code: _codeController.text.trim(),
                          ));
                  }
                }),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: <Widget>[
        AppTextField(
          controller: _titleController,
          isRequired: true,
          label: AppLocalizations.of(context)!.title,
        ),
        AppTextField(
          controller: _codeController,
          isRequired: true,
          label: AppLocalizations.of(context)!.code,
        ),
      ],
    );
  }
}
