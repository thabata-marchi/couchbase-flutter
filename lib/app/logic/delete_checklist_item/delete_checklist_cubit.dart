import 'package:checklist/app/repositories/checklist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'delete_checklist_state.dart';

class DeleteChecklistCubit extends Cubit<DeleteChecklistState> {
  final ChecklistRepository _repository;

  DeleteChecklistCubit(this._repository) : super(DeleteChecklistInitial());

  Future<void> deleteItem(int id) async {
    try {
      await _repository.deleteItem(id);
      emit(DeleteChecklistSuccess(id));
    } catch (e) {
      emit(DeleteChecklistError('Erro ao excluir item: $e'));
    }
  }
}
