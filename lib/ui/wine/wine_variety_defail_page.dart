import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kevin/bloc/wine_variety/wine_variety_bloc.dart';
import 'package:kevin/models/wine_variety_model.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_scaffold.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_icon_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';

class WineVarietyDetailPage extends StatefulWidget {
  final WineVarietyModel? wineVariety;
  const WineVarietyDetailPage({
    Key? key,
    this.wineVariety,
  }) : super(key: key);

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
    return BlocBuilder<WineVarietyBloc, WineVarietyState>(
      builder: (context, state) {
        return AppScaffold(
          body: _form(context),
          appBar: AppBar(
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
                              : BlocProvider.of<WineVarietyBloc>(context)
                                  .add(CreateWineVarietyEvent(title: _titleController.text, code: _codeController.text));
                        }
                      }),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
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
          const SizedBox(height: 10),
          AppTextField(
            controller: _titleController,
            isRequired: true,
            label: AppLocalizations.of(context)!.title,
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _codeController,
            isRequired: true,
            label: AppLocalizations.of(context)!.code,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
