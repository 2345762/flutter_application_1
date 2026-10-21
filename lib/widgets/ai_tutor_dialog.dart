import 'package:flutter/material.dart';
import '../services/ai_tutor_service.dart';
import 'typewriter_text.dart';

class AiTutorDialog extends StatefulWidget {
  final String formQuestion;
  final String correctAnswer;
  final String theoreticalExplanation;
  final AiTutorService aiTutorService;

  const AiTutorDialog({
    super.key,
    required this.formQuestion,
    required this.correctAnswer,
    required this.theoreticalExplanation,
    required this.aiTutorService,
  });

  static Future<void> show(
    BuildContext context, {
    required String formQuestion,
    required String correctAnswer,
    required String theoreticalExplanation,
    AiTutorService? aiTutorService,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AiTutorDialog(
        formQuestion: formQuestion,
        correctAnswer: correctAnswer,
        theoreticalExplanation: theoreticalExplanation,
        aiTutorService: aiTutorService ?? AiTutorService(),
      ),
    );
  }

  @override
  State<AiTutorDialog> createState() => _AiTutorDialogState();
}

class _AiTutorDialogState extends State<AiTutorDialog> {
  final TextEditingController _doubtController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isRetryable = true;

  @override
  void dispose() {
    _doubtController.dispose();
    super.dispose();
  }

  Future<void> _submitDoubt() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isRetryable = true;
      _response = '';
    });

    try {
      final answer = await widget.aiTutorService.askTutor(
        studentDoubt: _doubtController.text,
        formQuestion: widget.formQuestion,
        correctAnswer: widget.correctAnswer,
        theoreticalExplanation: widget.theoreticalExplanation,
      );

      if (!mounted) return;

      setState(() {
        _response = answer;
        _isLoading = false;
      });
    } on AiTutorException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.message;
        _isRetryable = e.isRetryable;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Ocurrió un error inesperado al procesar tu solicitud.';
        _isRetryable = true;
        _isLoading = false;
      });
    }
  }

  void _retry() {
    _submitDoubt();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool hasAnswered = _response.isNotEmpty;

    return Container(
      constraints: BoxConstraints(
        maxWidth: 600,
        maxHeight: screenHeight * 0.88,
      ),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 12,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology_outlined,
                        color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Tutor IA: Consulta de Pregunta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDarkMode ? Colors.white10 : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      widget.formQuestion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Question Input Section: Only displayed ONCE before the AI delivers its response
            if (!hasAnswered) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _doubtController,
                  maxLines: 3,
                  maxLength: 500,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: '¿Por qué esta opción es la correcta? ¿Qué concepto no te quedó claro?',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white38 : Colors.grey.shade500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
                        width: 2,
                      ),
                    ),
                    counterText: '',
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),

              const SizedBox(height: 12),

              // Submit button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton.icon(
                  onPressed: (_isLoading || _doubtController.text.trim().isEmpty)
                      ? null
                      : _submitDoubt,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 18),
                  label: Text(
                    _isLoading ? 'Consultando al Tutor...' : 'Preguntar al Tutor IA',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.blue.shade600 : Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
              ),
            ],

            // Response area or error
            if (hasAnswered || _errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _errorMessage != null
                      ? (isDarkMode ? Colors.red.withValues(alpha: 0.12) : Colors.red.shade50)
                      : (isDarkMode ? const Color(0xFF2C2C2E) : Colors.blue.shade50),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _errorMessage != null
                        ? (isDarkMode ? Colors.red.withValues(alpha: 0.35) : Colors.red.shade200)
                        : (isDarkMode ? Colors.blue.withValues(alpha: 0.3) : Colors.blue.shade200),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _errorMessage != null ? Icons.error_outline : Icons.school_outlined,
                          color: _errorMessage != null
                              ? (isDarkMode ? Colors.red.shade300 : Colors.red.shade700)
                              : (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _errorMessage != null ? 'Aviso' : 'Explicación del Instructor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _errorMessage != null
                                ? (isDarkMode ? Colors.red.shade300 : Colors.red.shade700)
                                : (isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_errorMessage != null)
                      SelectableText(
                        _errorMessage!,
                        style: TextStyle(
                          color: isDarkMode ? Colors.red.shade200 : Colors.red.shade900,
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      )
                    else
                      TypewriterText(
                        text: _response,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontSize: 13.5,
                          height: 1.5,
                        ),
                      ),
                    if (_errorMessage != null && _isRetryable) ...[
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _retry,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Intentar nuevamente'),
                        style: TextButton.styleFrom(
                          foregroundColor: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              if (hasAnswered) ...[
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDarkMode ? Colors.white70 : Colors.black87,
                      side: BorderSide(
                        color: isDarkMode ? Colors.white24 : Colors.grey.shade400,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Entendido, cerrar'),
                  ),
                ),
              ],
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
