import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DebugAiBridgeCard extends StatefulWidget {
  const DebugAiBridgeCard({super.key});

  @override
  State<DebugAiBridgeCard> createState() => _DebugAiBridgeCardState();
}

class _DebugAiBridgeCardState extends State<DebugAiBridgeCard> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _endpointController = TextEditingController(
    text: 'http://10.0.2.2:1234/v1/chat/completions',
  );
  final TextEditingController _modelController = TextEditingController(
    text: 'gpt-4.1-mini',
  );
  final TextEditingController _tokenController = TextEditingController();

  final List<_ChatMessage> _messages = <_ChatMessage>[];
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _endpointController.dispose();
    _modelController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4) Chat IA desde Emulador (Debug)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Conecta el emulador a un endpoint compatible con OpenAI Chat Completions. Ideal para hablar con tu asistente mientras pruebas en debug.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Nota: esta tarjeta no se conecta de forma nativa a la sesion de Copilot Chat en VS Code; usa un endpoint IA externo o local.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'Endpoint',
                hintText: 'http://10.0.2.2:1234/v1/chat/completions',
                prefixIcon: Icon(Icons.link_rounded),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Modelo',
                hintText: 'gpt-4.1-mini o local-model',
                prefixIcon: Icon(Icons.memory_rounded),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _tokenController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Bearer token (opcional)',
                hintText: 'sk-... (si tu endpoint lo requiere)',
                prefixIcon: Icon(Icons.key_rounded),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              constraints: const BoxConstraints(minHeight: 80, maxHeight: 220),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'Sin mensajes aún. Escribe tu pregunta abajo.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final bubbleColor = message.isUser
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surface;
                        final textColor = message.isUser
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface;

                        return Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(10),
                              border: message.isUser
                                  ? null
                                  : Border.all(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                    ),
                            ),
                            child: Text(
                              message.text,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje para el asistente...',
                      prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isSending ? null : _sendMessage,
                  icon: _isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
                  label: const Text('Enviar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tip Android Emulator: 10.0.2.2 apunta a localhost de tu máquina.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final userMessage = _messageController.text.trim();
    final endpoint = _endpointController.text.trim();
    final model = _modelController.text.trim();
    final token = _tokenController.text.trim();

    if (userMessage.isEmpty || endpoint.isEmpty || model.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
      _messages.add(_ChatMessage(text: userMessage, isUser: true));
      _messageController.clear();
    });

    try {
      final headers = <String, String>{'Content-Type': 'application/json'};
      if (token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .post(
            Uri.parse(endpoint),
            headers: headers,
            body: jsonEncode({
              'model': model,
              'messages': [
                {
                  'role': 'system',
                  'content': 'You are a helpful coding assistant.',
                },
                {'role': 'user', 'content': userMessage},
              ],
              'temperature': 0.3,
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (!mounted) {
        return;
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        setState(() {
          _messages.add(
            _ChatMessage(
              text: 'Error ${response.statusCode}: ${response.body}',
              isUser: false,
            ),
          );
        });
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final choices = data['choices'];
      String assistantText = 'No response';

      if (choices is List && choices.isNotEmpty) {
        final firstChoice = choices.first;
        if (firstChoice is Map<String, dynamic>) {
          final message = firstChoice['message'];
          if (message is Map<String, dynamic>) {
            final content = message['content'];
            if (content is String && content.trim().isNotEmpty) {
              assistantText = content.trim();
            }
          }
        }
      }

      setState(() {
        _messages.add(_ChatMessage(text: assistantText, isUser: false));
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _messages.add(
          _ChatMessage(
            text:
                'No se pudo conectar. Verifica endpoint/model/token y que el servidor esté activo. Detalle: $error',
            isUser: false,
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}
