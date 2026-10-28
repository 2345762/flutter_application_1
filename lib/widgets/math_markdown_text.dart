import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';

/// A robust widget that renders mixed Markdown and LaTeX mathematics.
/// Fully compatible with Flutter Web (CanvasKit and HTML/Wasm).
///
/// Supports:
/// - Display / block equations: `$$...$$` and `\[...\]`
/// - Inline equations: `$...$` and `\(...\)`
/// - Bold text: `**text**`
/// - Italic text: `*text*`
/// - Bulleted lists: `- ` and `* `
/// - Numbered lists: `1. `, `2. `, etc.
/// - Headings: `### `, `## `, `# `
/// - Highlighted Source section: `Fuente: ...` or `fuente: ...`
class MathMarkdownText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool? isDarkMode;
  final bool selectable;

  const MathMarkdownText({
    super.key,
    required this.text,
    this.style,
    this.isDarkMode,
    this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final darkMode = isDarkMode ?? (theme.brightness == Brightness.dark);
    final defaultStyle = style ??
        TextStyle(
          fontSize: 13.5,
          height: 1.5,
          color: darkMode ? Colors.white : Colors.black87,
        );

    final blocks = _parseBlocks(text);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: blocks.map((block) => _buildBlock(block, defaultStyle, darkMode)).toList(),
    );

    if (selectable) {
      return SelectionArea(child: content);
    }
    return content;
  }

  Widget _buildBlock(_Block block, TextStyle defaultStyle, bool darkMode) {
    switch (block.type) {
      case _BlockType.displayMath:
        return _buildDisplayMath(block.content, defaultStyle, darkMode);

      case _BlockType.source:
        return _buildSourceBadge(block.content, defaultStyle, darkMode);

      case _BlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 4),
          child: _buildRichText(block.content, defaultStyle.copyWith(
            fontSize: (defaultStyle.fontSize ?? 14) + 1.5,
            fontWeight: FontWeight.bold,
            color: darkMode ? Colors.blue.shade200 : Colors.blue.shade800,
          ), darkMode),
        );

      case _BlockType.bullet:
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style: defaultStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: darkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
              ),
              Expanded(
                child: _buildRichText(block.content, defaultStyle, darkMode),
              ),
            ],
          ),
        );

      case _BlockType.numbered:
        return Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${block.prefix} ',
                style: defaultStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: darkMode ? Colors.blue.shade300 : Colors.blue.shade700,
                ),
              ),
              Expanded(
                child: _buildRichText(block.content, defaultStyle, darkMode),
              ),
            ],
          ),
        );

      case _BlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: _buildRichText(block.content, defaultStyle, darkMode),
        );
    }
  }

  Widget _buildDisplayMath(String tex, TextStyle defaultStyle, bool darkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: darkMode
            ? Colors.black.withValues(alpha: 0.25)
            : Colors.blue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: darkMode
              ? Colors.blue.withValues(alpha: 0.25)
              : Colors.blue.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Math.tex(
            tex.trim(),
            mathStyle: MathStyle.display,
            textStyle: defaultStyle.copyWith(
              fontSize: (defaultStyle.fontSize ?? 14) + 1.5,
              color: darkMode ? Colors.white : Colors.black87,
            ),
            onErrorFallback: (err) {
              return Text(
                tex,
                style: defaultStyle.copyWith(
                  fontFamily: 'monospace',
                  color: Colors.amber.shade700,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSourceBadge(String sourceText, TextStyle defaultStyle, bool darkMode) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: darkMode
            ? Colors.blue.withValues(alpha: 0.1)
            : Colors.blue.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: darkMode
              ? Colors.blue.withValues(alpha: 0.3)
              : Colors.blue.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.menu_book_rounded,
            size: 15,
            color: darkMode ? Colors.blue.shade300 : Colors.blue.shade700,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildRichText(
              sourceText,
              defaultStyle.copyWith(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: darkMode ? Colors.blue.shade200 : Colors.blue.shade900,
              ),
              darkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichText(String rawText, TextStyle baseStyle, bool darkMode) {
    final spans = _parseInlineSpans(rawText, baseStyle, darkMode);
    return Text.rich(
      TextSpan(children: spans),
      style: baseStyle,
    );
  }

  List<InlineSpan> _parseInlineSpans(String rawText, TextStyle baseStyle, bool darkMode) {
    final spans = <InlineSpan>[];
    // Regex matching:
    // 1. Display math inside paragraph: `$$...$$`
    // 2. Bracket display math: `\[...\]`
    // 3. Inline math: `$...$` or `\(...\)`
    // 4. Bold: `**...**`
    // 5. Italic: `*...*`
    final pattern = RegExp(
      r'(\$\$(.+?)\$\$)|(\\\[(.+?)\\\])|((?<!\\)\$(?!\$)(.+?)(?<!\\)\$)|(\\\((.+?)\\\))|(\*\*(.+?)\*\*)|(\*(.+?)\*)',
      dotAll: true,
    );

    int lastIndex = 0;

    for (final match in pattern.allMatches(rawText)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: rawText.substring(lastIndex, match.start),
          style: baseStyle,
        ));
      }


      if (match.group(1) != null) {
        // $$...$$ display math inline
        final mathContent = match.group(2)!.trim();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Math.tex(
                mathContent,
                mathStyle: MathStyle.display,
                textStyle: baseStyle,
                onErrorFallback: (err) => Text('\$$mathContent\$', style: baseStyle),
              ),
            ),
          ),
        );
      } else if (match.group(3) != null) {
        // \[...\] display math
        final mathContent = match.group(4)!.trim();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Math.tex(
                mathContent,
                mathStyle: MathStyle.display,
                textStyle: baseStyle,
                onErrorFallback: (err) => Text('\\[$mathContent\\]', style: baseStyle),
              ),
            ),
          ),
        );
      } else if (match.group(5) != null) {
        // $...$ inline math
        final mathContent = match.group(6)!.trim();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Math.tex(
                mathContent,
                mathStyle: MathStyle.text,
                textStyle: baseStyle,
                onErrorFallback: (err) => Text('\$$mathContent\$', style: baseStyle),
              ),
            ),
          ),
        );
      } else if (match.group(7) != null) {
        // \(...\) inline math
        final mathContent = match.group(8)!.trim();
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Math.tex(
                mathContent,
                mathStyle: MathStyle.text,
                textStyle: baseStyle,
                onErrorFallback: (err) => Text('\\($mathContent\\)', style: baseStyle),
              ),
            ),
          ),
        );
      } else if (match.group(9) != null) {
        // **bold**
        final boldContent = match.group(10)!;
        spans.add(TextSpan(
          text: boldContent,
          style: baseStyle.copyWith(fontWeight: FontWeight.bold),
        ));
      } else if (match.group(11) != null) {
        // *italic*
        final italicContent = match.group(12)!;
        spans.add(TextSpan(
          text: italicContent,
          style: baseStyle.copyWith(fontStyle: FontStyle.italic),
        ));
      }

      lastIndex = match.end;
    }

    if (lastIndex < rawText.length) {
      spans.add(TextSpan(
        text: rawText.substring(lastIndex),
        style: baseStyle,
      ));
    }

    return spans;
  }

  List<_Block> _parseBlocks(String input) {
    final blocks = <_Block>[];
    final normalized = input.replaceAll('\r\n', '\n');

    // First, split out top-level display math blocks: `$$...$$` and `\[...\]`
    final displayMathRegex = RegExp(r'(\$\$(.*?)\$\$)|(\\\[(.*?)\\\])', dotAll: true);
    int lastPos = 0;

    for (final match in displayMathRegex.allMatches(normalized)) {
      if (match.start > lastPos) {
        final textChunk = normalized.substring(lastPos, match.start);
        _parseTextLinesIntoBlocks(textChunk, blocks);
      }

      final mathCode = (match.group(2) ?? match.group(4) ?? '').trim();
      if (mathCode.isNotEmpty) {
        blocks.add(_Block(type: _BlockType.displayMath, content: mathCode));
      }

      lastPos = match.end;
    }

    if (lastPos < normalized.length) {
      final remaining = normalized.substring(lastPos);
      _parseTextLinesIntoBlocks(remaining, blocks);
    }

    return blocks;
  }

  void _parseTextLinesIntoBlocks(String textChunk, List<_Block> blocks) {
    final lines = textChunk.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trimRight();
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        continue;
      }

      // Check for source reference: `Fuente:` or `fuente:`
      if (trimmed.toLowerCase().startsWith('fuente:')) {
        blocks.add(_Block(type: _BlockType.source, content: trimmed));
        continue;
      }

      // Check for headers: `### `, `## `, `# `
      if (trimmed.startsWith('### ')) {
        blocks.add(_Block(type: _BlockType.heading, content: trimmed.substring(4)));
        continue;
      }
      if (trimmed.startsWith('## ')) {
        blocks.add(_Block(type: _BlockType.heading, content: trimmed.substring(3)));
        continue;
      }
      if (trimmed.startsWith('# ')) {
        blocks.add(_Block(type: _BlockType.heading, content: trimmed.substring(2)));
        continue;
      }

      // Check for bullet lists: `- `, `* `, `• `
      if (trimmed.startsWith('- ') || trimmed.startsWith('* ') || trimmed.startsWith('• ')) {
        blocks.add(_Block(type: _BlockType.bullet, content: trimmed.substring(2)));
        continue;
      }

      // Check for numbered lists: `1. `, `2. `, etc.
      final numberedMatch = RegExp(r'^(\d+[\.\)])\s+(.*)$').firstMatch(trimmed);
      if (numberedMatch != null) {
        blocks.add(_Block(
          type: _BlockType.numbered,
          prefix: numberedMatch.group(1)!,
          content: numberedMatch.group(2)!,
        ));
        continue;
      }

      // Regular paragraph
      blocks.add(_Block(type: _BlockType.paragraph, content: trimmed));
    }
  }
}

enum _BlockType {
  paragraph,
  displayMath,
  bullet,
  numbered,
  heading,
  source,
}

class _Block {
  final _BlockType type;
  final String content;
  final String? prefix;

  _Block({
    required this.type,
    required this.content,
    this.prefix,
  });
}
