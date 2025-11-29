// filename: lib/widgets/code_editor_placeholder.dart

import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// A polished code editor placeholder with line numbers and basic syntax highlighting
class CodeEditorPlaceholder extends StatefulWidget {
  final String initialCode;
  final VoidCallback? onRun;

  const CodeEditorPlaceholder({
    Key? key,
    this.initialCode = '',
    this.onRun,
  }) : super(key: key);

  @override
  State<CodeEditorPlaceholder> createState() => _CodeEditorPlaceholderState();
}

class _CodeEditorPlaceholderState extends State<CodeEditorPlaceholder> {
  late TextEditingController _controller;
  String _output = '';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCode);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runCode() {
    setState(() {
      _isRunning = true;
    });

    // Simulate code execution
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _isRunning = false;
        _output = '✓ Code executed successfully!\nOutput: Hello, World!\n';
      });
    });

    if (widget.onRun != null) widget.onRun!();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Editor header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                _buildDot(Colors.red),
                const SizedBox(width: 8),
                _buildDot(Colors.yellow),
                const SizedBox(width: 8),
                _buildDot(Colors.green),
                const SizedBox(width: 16),
                const Text(
                  'main.py',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Code editor area with line numbers
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers
                Container(
                  width: 40,
                  padding: const EdgeInsets.only(top: 16, right: 8),
                  color: const Color(0xFF252525),
                  child: Column(
                    children: List.generate(
                      _controller.text.split('\n').length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          '${index + 1}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF858585),
                            fontSize: 13,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Code input
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: 'Write your code here...',
                      hintStyle: TextStyle(color: Color(0xFF555555)),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Refresh line numbers
                    },
                  ),
                ),
              ],
            ),
          ),

          // Output area
          if (_output.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A),
                border: Border(
                  top: BorderSide(color: Color(0xFF3D3D3D), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Output:',
                    style: TextStyle(
                      color: Color(0xFF4EC9B0),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _output,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

          // Run button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _isRunning ? null : _runCode,
              icon: _isRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.play_arrow, size: 20),
              label: Text(_isRunning ? 'Running...' : 'Run Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen, // FIXED
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
