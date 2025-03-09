import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mood_app/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// ✅ Realtime 구독 (메시지 수신)
  Stream<List<MessageModel>> subscribeToMessages() {
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((row) => MessageModel.fromJson(row)).toList());
  }

  /// ✅ 메시지 삽입 (DB로 전송)
  Future<void> sendMessage(String mood, String content) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await _supabase.from('messages').insert({
      'user_id': userId,
      'mood': mood,
      'content': content,
    });

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }

  /// ✅ 메시지 삭제 (ID 기반)
  Future<void> deleteMessage(String messageId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await _supabase.from('messages').delete().match({
      'id': messageId, // 🔹 UUID는 String 타입
      'user_id': userId, // 사용자가 본인의 메시지만 삭제 가능하도록 체크
    });

    if (response.error != null) {
      throw Exception(response.error!.message);
    }
  }
}

final gMessageRepositoryProvider = Provider((ref) => MessageRepository());
