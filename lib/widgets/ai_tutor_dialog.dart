import 'package:flutter/material.dart';
import '../services/ai_tutor_service.dart';

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
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Ocurrió un error inesperado. Por favor, intenta nuevamente.';
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

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tutor IA',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.blue.withValues(alpha: 0.1) : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDarkMode ? Colors.blue.withValues(alpha: 0.3) : Colors.blue.shade200,
                    ),
                  ),
                  child: Text(
                    'Solo responde según la teoría de esta pregunta',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _doubtController,
              maxLines: 3,
              maxLength: 500,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Escribe tu duda sobre esta pregunta...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
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

          const SizedBox(height: 16),

          // Send button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isLoading || _doubtController.text.trim().isEmpty)
                    ? null
                    : _submitDoubt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blue.shade600 : Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Preguntar al Tutor IA',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ),

          // Response area
          if (_response.isNotEmpty || _errorMessage != null) ...[
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _errorMessage != null
                    ? (isDarkMode ? Colors.red.withValues(alpha: 0.1) : Colors.red.shade50)
                    : (isDarkMode ? Colors.green.withValues(alpha: 0.1) : Colors.green.shade50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _errorMessage != null
                      ? (isDarkMode ? Colors.red.withValues(alpha: 0.3) : Colors.red.shade200)
                      : (isDarkMode ? Colors.green.withValues(alpha: 0.3) : Colors.green.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _errorMessage != null ? Icons.error_outline : Icons.check_circle_outline,
                        color: _errorMessage != null
                            ? (isDarkMode ? Colors.red.shade300 : Colors.red.shade700)
                            : (isDarkMode ? Colors.green.shade300 : Colors.green.shade700),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _errorMessage != null ? 'Error' : 'Respuesta',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _errorMessage != null
                              ? (isDarkMode ? Colors.red.shade300 : Colors.red.shade700)
                              : (isDarkMode ? Colors.green.shade300 : Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _errorMessage ?? _response,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Intentar nuevamente'),
                      style: TextButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}