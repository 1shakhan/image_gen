import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gen/api/mock.api.service.dart';
import 'package:image_gen/router/scope.dart';
import 'package:image_gen/state/image.list.state.dart';
import 'package:image_gen/state/image.loading.state.dart';
import 'package:image_gen/state/image.proc.state.dart';
import 'package:image_gen/state/image.prompt.state.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: Stack(children: [_ImageProcessedCount(), const _ResultProcess(), const _ResultControlButtons()]),
    );
  }
}

class _ResultProcess extends StatelessWidget {
  const _ResultProcess();

  Future<String?> getImage(BuildContext context) async {
    final prompt = context.read<ImagePromptState>().state;
    try {
      context.read<ImageProcState>().next();
      final link = await MockApiService().getImageLink();
      context.read<ImageListState>().add(link, prompt);
      context.read<ImageProcState>().clear();
      return link;
    } catch (e) {
      context.read<ImageListState>().add(null, prompt);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
      child: BlocBuilder<ImageLoadingState, int?>(
        builder: (context, state) {
          return FutureBuilder(
            future: getImage(context),
            builder: (context, snap) {
              Widget child;
              if (snap.connectionState == ConnectionState.waiting || !snap.hasData && !snap.hasError) {
                child = Center(
                  key: const ValueKey('loader'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        width: 220,
                        height: 220,
                        child: const CircularProgressIndicator(color: Colors.blue),
                      ),
                      Text('Loading...', style: TextTheme.of(context).titleLarge?.copyWith(color: Colors.blue)),
                    ],
                  ),
                );
              } else if (snap.hasError) {
                child = Center(
                  key: const ValueKey('error'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 240, color: Colors.redAccent),
                      OutlinedButton.icon(
                        onPressed: context.read<ImageLoadingState>().next,
                        label: const Text('Retry'),
                        icon: const Icon(Icons.refresh),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          side: const BorderSide(color: Colors.redAccent, width: 0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                child = Center(
                  key: ValueKey(snap.data),
                  child: Image.network(snap.data ?? '', fit: BoxFit.cover),
                );
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: child,
              );
            },
          );
        },
      ),
    );
  }
}

class _ResultControlButtons extends StatelessWidget {
  const _ResultControlButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageProcState, int?>(
      builder: (context, procState) {
        return BlocBuilder<ImageListState, List<ImageLoadProcResult>>(
          builder: (context, state) {
            final enabled = procState == null && state.lastOrNull?.error == false;
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 25, top: 10),
                width: double.infinity,
                height: 95,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<Color?>(
                      tween: ColorTween(end: enabled ? Colors.blue : Colors.grey),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, color, child) {
                        return OutlinedButton.icon(
                          onPressed: enabled ? () => tryAnother(context) : null,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                            side: BorderSide(color: color ?? Colors.grey, width: 0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            disabledForegroundColor: color?.withOpacity(0.38),
                          ),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Try another'),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => newPrompt(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                        side: const BorderSide(color: Colors.blue, width: 0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('New prompt'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  newPrompt(BuildContext context) {
    return RouterScope.managerOf(context).pop();
  }

  tryAnother(BuildContext context) {
    context.read<ImageLoadingState>().next();
  }
}

class _ImageProcessedCount extends StatefulWidget {
  @override
  State<_ImageProcessedCount> createState() => _ImageProcessedCountState();
}

class _ImageProcessedCountState extends State<_ImageProcessedCount> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final Animation<double> _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
  late OverlayEntry? overlayBackground;
  late OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageListState, List<ImageLoadProcResult>>(
      builder: (context, list) {
        return Align(
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: () => showList(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: Text(
                list.isNotEmpty
                    ? 'Generated ${list.length} time${list.length > 1 ? 's' : ''}'
                    : 'Generating first image...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

  OverlayEntry get overlayBackgroundWidget => OverlayEntry(
    builder: (context) {
      return Positioned.fill(
        child: FadeTransition(
          opacity: _opacity,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.15)),
            ),
          ),
        ),
      );
    },
  );

  OverlayEntry get overlayEntryWidget => OverlayEntry(
    builder: (context) {
      return FadeTransition(
        opacity: _opacity,
        child: GestureDetector(
          onTap: removeOverlays,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BlocBuilder<ImageListState, List<ImageLoadProcResult>>(
                  builder: (context, dataList) {
                    if (dataList.isEmpty) {
                      return const Center(
                        child: Text('No data yet', style: TextStyle(color: Colors.black54)),
                      );
                    }
                    final list = [
                      SizedBox(height: 30),
                      ...dataList.map((data) => _ImageProcResult(data: data)),
                      Row(
                        spacing: 12,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => deleteAll(context),
                            label: const Text('Delete all'),
                            icon: const Icon(Icons.clear),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                              side: const BorderSide(color: Colors.redAccent, width: 0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              maximumSize: const Size(250, 40),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: removeOverlays,
                            label: const Text('Close'),
                            icon: const Icon(Icons.close_fullscreen),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                              side: const BorderSide(color: Colors.blueAccent, width: 0.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              maximumSize: const Size(250, 40),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ];
                    return ListView(children: list);
                  },
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  void showList(BuildContext context) {
    final overlay = Overlay.of(context);
    overlayBackground = overlayBackgroundWidget;
    overlayEntry = overlayEntryWidget;
    overlay.insertAll([overlayBackground!, overlayEntry!]);
    _controller.forward();
  }

  Future<void> removeOverlays() async {
    await _controller.reverse();
    overlayEntry?.remove();
    overlayBackground?.remove();
    overlayEntry = null;
    overlayBackground = null;
  }

  void deleteAll(BuildContext context) {
    context.read<ImageListState>().clear();
    removeOverlays();
    RouterScope.managerOf(context).pop();
  }
}

class _ImageProcResult extends StatelessWidget {
  const _ImageProcResult({required this.data});

  final ImageLoadProcResult data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: data.error
                      ? const Icon(Icons.error_outline, color: Colors.redAccent)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(data.link ?? '', fit: BoxFit.cover),
                        ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prompt: ${data.prompt ?? 'no-prompt'}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.black87),
                      ),
                      Text(
                        'Link: ${data.link ?? 'no-link'}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        'At: ${DateFormat('y/MM/dd HH:mm:ss').format(data.time)}',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
