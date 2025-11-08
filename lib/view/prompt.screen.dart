import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gen/router/route.enum.dart';
import 'package:image_gen/router/scope.dart';
import 'package:image_gen/state/image.prompt.state.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final double circleRadius = 8.0;
  String promptInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Awesome image generator')),
      body: Container(
        margin: EdgeInsets.only(top: 12),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  filled: true,
                  hintText: 'Describe what you want to see…',
                  helperStyle: TextStyle(fontStyle: FontStyle.italic),
                  fillColor: Colors.white70,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(circleRadius),
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(circleRadius),
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    promptInput = value;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.only(bottom: 25, top: 10),
                width: double.infinity,
                height: 95,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: OutlinedButton.icon(
                    onPressed: promptInput.isEmpty ? null : () => openResult(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                      side: BorderSide(color: promptInput.isEmpty ? Colors.grey : Colors.blue, width: 0.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(circleRadius)),
                    ),
                    icon: Icon(Icons.auto_awesome),
                    label: Text('Generate'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openResult(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<ImagePromptState>().next(promptInput);
    return RouterScope.managerOf(context).push(AppPage.result);
  }
}
