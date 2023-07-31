import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/repository/wine_classification_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

part 'wine_classification_event.dart';
part 'wine_classification_state.dart';

class WineClassificationBloc extends Bloc<WineClassificationEvent, WineClassificationState> {
  final WineClassificationRepository wineClassificationRepository;
  final AppPreferences appPreferences = instance<AppPreferences>();

  WineClassificationBloc(this.wineClassificationRepository) : super(WineClassificationInitial()) {
    on<WineClassificationListEvent>((event, emit) async {
      emit(WineClassificationLoadingState());
      try {
        late List<WineClassificationModel> list;
        list = await wineClassificationRepository.getWineClassificationList();
        await appPreferences.setWineClassifications(list);
        emit(WineClassificationListSuccessState(list));
      } on Exception catch (e) {
        emit(WineClassificationFailureState(e.toString()));
      }
    });
  }
}
