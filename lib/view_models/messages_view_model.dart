import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mood_app/models/message_model.dart';
import 'package:mood_app/repos/messages_repository.dart';
import 'package:mood_app/utils/utils.dart';

class MessageViewModel extends AsyncNotifier<List<MessageModel>> {
  late MessageRepository _repository;

  @override
  Future<List<MessageModel>> build() async {
    _repository = ref.read(gMessageRepositoryProvider);
    return _repository.subscribeToMessages().first;
  }

  /// ✅ Realtime 데이터 갱신
  void listenToMessages() {
    state = const AsyncLoading();
    _repository.subscribeToMessages().listen(
      (messages) {
        state = AsyncData(messages);
      },
      onError: (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  /// ✅ 메시지 전송 및 에러 처리
  Future<void> sendMessage(
    String mood,
    String content,
    BuildContext context,
  ) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
          await _repository.sendMessage(mood, content);
        })
        .then((_) {
          state = AsyncData([...?state.value]);
          if (context.mounted) {
            context.go('/home');
          }
        })
        .catchError((error) {
          state = AsyncError(error, StackTrace.current);
          if (context.mounted) {
            context.showSnackBar(error: error);
          }
        });
  }

  /// ✅ 메시지 전송 및 에러 처리
  Future<void> deleteMessage(String messageId, BuildContext context) async {
    state = const AsyncLoading();
    await AsyncValue.guard(() async {
          await _repository.deleteMessage(messageId);
        })
        .then((_) {
          state = AsyncData([...?state.value]);
        })
        .catchError((error) {
          state = AsyncError(error, StackTrace.current);
          if (context.mounted) {
            context.showSnackBar(error: error);
          }
        });
  }
}

final gMessageViewModelProvider =
    AsyncNotifierProvider<MessageViewModel, List<MessageModel>>(() {
      return MessageViewModel();
    });
