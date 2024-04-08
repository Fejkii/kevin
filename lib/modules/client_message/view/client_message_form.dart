import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_constant.dart';
import 'package:kevin/modules/client_message/bloc/client_message_bloc.dart';
import 'package:kevin/ui/widgets/app_form.dart';
import 'package:kevin/ui/widgets/app_loading_indicator.dart';
import 'package:kevin/ui/widgets/app_toast_messages.dart';
import 'package:kevin/ui/widgets/buttons/app_button.dart';
import 'package:kevin/ui/widgets/texts/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientMessageForm extends StatefulWidget {
  const ClientMessageForm({super.key});

  @override
  State<ClientMessageForm> createState() => _ClientMessageFormState();
}

class _ClientMessageFormState extends State<ClientMessageForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: _formKey,
      content: [
        AppTextField(
          controller: _titleController,
          isRequired: true,
          label: AppLocalizations.of(context)!.title,
        ),
        AppTextField(
          controller: _messageController,
          isRequired: true,
          label: AppLocalizations.of(context)!.message,
          inputType: InputType.note,
        ),
        _sendButton(),
      ],
    );
  }

  Widget _sendButton() {
    return BlocConsumer<ClientMessageBloc, ClientMessageState>(
      listener: (context, state) {
        if (state is ClientMessageSendedState) {
          setState(() {
            _titleController.text = AppConstant.EMPTY;
            _messageController.text = AppConstant.EMPTY;
          });
          Navigator.pop(context);
          AppToastMessage().showToastMsg(AppLocalizations.of(context)!.messageSended, ToastState.success);
        } else if (state is ClientMessageFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is ClientMessageLodadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppButton(
            title: AppLocalizations.of(context)!.sendMessage,
            onTap: () {
              _formKey.currentState!.validate()
                  ? BlocProvider.of<ClientMessageBloc>(context).add(
                      CreateClientMessageEvent(
                        title: _titleController.text.trim(),
                        message: _messageController.text.trim(),
                      ),
                    )
                  : null;
            },
          );
        }
      },
    );
  }
}
