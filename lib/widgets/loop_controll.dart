import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:ayat/provider/provider.dart';
import 'package:ayat/widgets/cnt.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoopControll extends StatefulWidget {
  final LoopMode? loopMode;
  final Function()? toggleLoop;
  
  LoopControll({
    this.loopMode,
    this.toggleLoop,
  });

  @override
  State<LoopControll> createState() => _LoopControllState();
}

class _LoopControllState extends State<LoopControll> {

  late ViewModelProvider viewModelProvider;
  bool loopChk=false;
   @override
  void initState() {
    super.initState();
     viewModelProvider = Provider.of<ViewModelProvider>(context, listen: false);

  }

  Widget _loopIcon(BuildContext context) {
    final iconSize = 34.0;
    if (widget.loopMode == LoopMode.none) {
      loopChk=false;
      viewModelProvider.setIsLoop(loopChk);
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.grey,
      );
    } else if (widget.loopMode == LoopMode.playlist) {
      loopChk=true;
      viewModelProvider.setIsLoop(loopChk);
      return Icon(
        Icons.loop,
        size: iconSize,
        color: Colors.amberAccent,
      );
    } else {
      //single
       loopChk=true;
      viewModelProvider.setIsLoop(loopChk);
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.loop,
            size: iconSize,
            color: Colors.white,
          ),
          Center(
            child: Text(
              '1',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.toggleLoop != null) widget.toggleLoop!();
      },
      child: _loopIcon(context),
    );
  }
}
