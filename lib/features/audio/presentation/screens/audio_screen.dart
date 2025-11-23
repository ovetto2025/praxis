import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:praxis/features/places/data/places_mock.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioScreen extends StatefulWidget {
  static const String routeName = '/audio';
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

enum PlayerStatus { idle, playing, paused }

class _AudioScreenState extends State<AudioScreen> {
  final FlutterTts _tts = FlutterTts();
  PlayerStatus _status = PlayerStatus.idle;
  double _volume = 0.7; // 0.0 - 1.0
  double _rate = 0.5; // 0.0 - 1.0
  double _pitch = 1.0; // 0.5 - 2.0

  List<String> _paragraphs = [];
  int _currentParagraphIndex = 0;
  bool _autoAdvance = true; // blocca avanzamento quando in pausa

  final ScrollController _scrollController = ScrollController();
  static const String _prefKeyIndex = 'audio_current_paragraph';
  static const String _prefKeyVolume = 'audio_volume';
  static const String _prefKeyRate = 'audio_rate';
  static const String _prefKeyPitch = 'audio_pitch';

  @override
  void initState() {
    super.initState();
    _prepareText();
    _loadPreferences();
    _configureTts();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt(_prefKeyIndex) ?? 0;
    final savedVolume = prefs.getDouble(_prefKeyVolume) ?? 0.7;
    final savedRate = prefs.getDouble(_prefKeyRate) ?? 0.5;

    setState(() {
      _currentParagraphIndex = savedIndex;
      _volume = savedVolume;
      _rate = savedRate;
    });

    await _applySettings();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToParagraph());
  }

  Future<void> _saveCurrentIndex() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyIndex, _currentParagraphIndex);
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefKeyVolume, _volume);
    await prefs.setDouble(_prefKeyRate, _rate);
    await prefs.setDouble(_prefKeyPitch, _pitch);
  }

  void _scrollToParagraph() {
    if (!_scrollController.hasClients) return;
    // Stima approssimativa: ogni paragrafo ha altezza variabile, scrolliamo proporzionalmente
    final estimatedHeight = _currentParagraphIndex * 300.0; // stima
    _scrollController.animateTo(
      estimatedHeight.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Future<void> _configureTts() async {
    await _tts.setLanguage('it-IT');
    await _tts.setVolume(_volume);
    await _tts.setSpeechRate(_rate);
    await _tts.setPitch(1.0); // Tonalità standard

    // Configurazione per audio in background
    await _tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
    ], IosTextToSpeechAudioMode.voicePrompt);

    // Android: abilita audio in background
    await _tts.awaitSpeakCompletion(false);

    _tts.setCompletionHandler(() async {
      if (_status == PlayerStatus.playing && _autoAdvance) {
        _currentParagraphIndex++;
        if (_currentParagraphIndex < _paragraphs.length) {
          await _speakCurrentParagraph();
        } else {
          if (mounted) {
            setState(() => _status = PlayerStatus.idle);
            _currentParagraphIndex = 0;
            await _saveCurrentIndex();
          }
        }
      }
    });

    _tts.setCancelHandler(() {
      // Cancel non distingue cause: rimaniamo nello stato corrente a meno di stop manuale
      if (mounted) {
        setState(() {
          if (_status == PlayerStatus.playing) {
            _status = PlayerStatus.idle;
            _currentParagraphIndex = 0;
          }
        });
      }
    });

    _tts.setErrorHandler((msg) {
      if (mounted) {
        setState(() => _status = PlayerStatus.idle);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Errore TTS: $msg')));
      }
    });
  }

  void _prepareText() {
    _paragraphs = [for (final p in placesMock) '${p.title}. ${p.description}'];
  }

  Future<void> _play() async {
    await _tts.stop();
    await _applySettings();
    // Se siamo idle riparte da inizio, se paused riparte dal paragrafo corrente
    if (_status == PlayerStatus.idle) {
      _currentParagraphIndex = 0;
    }
    _autoAdvance = true;
    await _speakCurrentParagraph();
    setState(() => _status = PlayerStatus.playing);
    await _saveCurrentIndex();
    _scrollToParagraph();
  }

  Future<void> _resume() async {
    if (_status != PlayerStatus.paused) return;
    await _applySettings();
    _autoAdvance = true;
    await _speakCurrentParagraph();
    setState(() => _status = PlayerStatus.playing);
  }

  Future<void> _pause() async {
    final result = await _tts.pause();
    if (result == 1) {
      _autoAdvance = false; // blocca avanzamento automatico
      setState(() => _status = PlayerStatus.paused);
      await _saveCurrentIndex();
    }
  }

  Future<void> _stop() async {
    final result = await _tts.stop();
    if (result == 1) {
      _autoAdvance = false;
      _currentParagraphIndex = 0;
      setState(() => _status = PlayerStatus.idle);
      await _saveCurrentIndex();
      _scrollToParagraph();
    }
  }

  Future<void> _applySettings() async {
    await _tts.setVolume(_volume);
    await _tts.setSpeechRate(_rate);
    await _tts.setPitch(_pitch);
  }

  Future<void> _speakCurrentParagraph() async {
    if (_currentParagraphIndex < 0 ||
        _currentParagraphIndex >= _paragraphs.length) {
      if (mounted) {
        setState(() => _status = PlayerStatus.idle);
      }
      return;
    }

    final text = _paragraphs[_currentParagraphIndex];
    if (text.isEmpty) {
      if (mounted) {
        setState(() => _status = PlayerStatus.idle);
      }
      return;
    }

    final result = await _tts.speak(text);

    // Se speak fallisce, torna a idle
    if (result == 0 && mounted) {
      setState(() => _status = PlayerStatus.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossibile avviare la riproduzione audio'),
        ),
      );
    }

    _scrollToParagraph();
  }

  @override
  void dispose() {
    _tts.stop();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Audio Percorso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Riproduzione Audio',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: _buildHighlightedText(),
              ),
            ),
            const SizedBox(height: 12),
            _controls(colors),
            const SizedBox(height: 12),
            _slider('Volume', _volume, (v) async {
              setState(() => _volume = v);
              await _tts.setVolume(_volume);
              await _saveSettings();
            }),
            _slider('Velocità', _rate, (v) async {
              setState(() => _rate = v);
              await _tts.setSpeechRate(_rate);
              await _saveSettings();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText() {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < _paragraphs.length; i++)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: i == _currentParagraphIndex
                  ? colors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: i == _currentParagraphIndex
                  ? Border.all(color: colors.primary, width: 2)
                  : null,
            ),
            child: Text(
              _paragraphs[i],
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                fontWeight: i == _currentParagraphIndex
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: i == _currentParagraphIndex
                    ? colors.primary
                    : Colors.black87,
              ),
            ),
          ),
      ],
    );
  }

  Widget _controls(ColorScheme colors) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              tooltip: 'Indietro paragrafo',
              iconSize: 36,
              color: _currentParagraphIndex > 0
                  ? colors.primary
                  : colors.primary.withValues(alpha: 0.3),
              onPressed: _currentParagraphIndex > 0 ? _previousParagraph : null,
              icon: const Icon(Icons.skip_previous),
            ),
            if (_status == PlayerStatus.idle)
              IconButton(
                tooltip: 'Play',
                iconSize: 42,
                color: colors.primary,
                icon: const Icon(Icons.play_arrow),
                onPressed: _play,
              ),
            if (_status == PlayerStatus.playing) ...[
              IconButton(
                tooltip: 'Pausa',
                iconSize: 42,
                color: colors.primary,
                icon: const Icon(Icons.pause),
                onPressed: _pause,
              ),
              IconButton(
                tooltip: 'Stop',
                iconSize: 42,
                color: colors.primary,
                icon: const Icon(Icons.stop),
                onPressed: _stop,
              ),
            ] else if (_status == PlayerStatus.paused) ...[
              IconButton(
                tooltip: 'Riprendi',
                iconSize: 42,
                color: colors.primary,
                icon: const Icon(Icons.play_arrow),
                onPressed: _resume,
              ),
              IconButton(
                tooltip: 'Stop',
                iconSize: 42,
                color: colors.primary,
                icon: const Icon(Icons.stop),
                onPressed: _stop,
              ),
            ],
            IconButton(
              tooltip: 'Avanti paragrafo',
              iconSize: 36,
              color: _currentParagraphIndex < _paragraphs.length - 1
                  ? colors.primary
                  : colors.primary.withValues(alpha: 0.3),
              onPressed: _currentParagraphIndex < _paragraphs.length - 1
                  ? _nextParagraph
                  : null,
              icon: const Icon(Icons.skip_next),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Ripeti paragrafo',
              iconSize: 32,
              color: colors.primary,
              onPressed: _repeatParagraph,
              icon: const Icon(Icons.repeat),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Paragrafo ${_currentParagraphIndex + 1} di ${_paragraphs.length}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Future<void> _repeatParagraph() async {
    await _tts.stop();
    await _speakCurrentParagraph();
    if (_status == PlayerStatus.idle) {
      setState(() => _status = PlayerStatus.playing);
    }
  }

  Future<void> _nextParagraph() async {
    if (_currentParagraphIndex < _paragraphs.length - 1) {
      _currentParagraphIndex++;
      if (_status == PlayerStatus.playing) {
        await _tts.stop();
        await _speakCurrentParagraph();
      } else {
        setState(() {});
      }
      await _saveCurrentIndex();
      _scrollToParagraph();
    }
  }

  Future<void> _previousParagraph() async {
    if (_currentParagraphIndex > 0) {
      _currentParagraphIndex--;
      if (_status == PlayerStatus.playing) {
        await _tts.stop();
        await _speakCurrentParagraph();
      } else {
        setState(() {});
      }
      await _saveCurrentIndex();
      _scrollToParagraph();
    }
  }

  Widget _slider(
    String label,
    double value,
    ValueChanged<double> onChanged, {
    double min = 0.0,
    double max = 1.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 10,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
