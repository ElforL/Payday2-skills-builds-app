import 'package:flutter/material.dart';
import 'package:pd2_builds/constants.dart';
import 'package:pd2_builds/screens/BuildsSceens/Components/Icons.dart';
import 'package:pd2_builds/skills/Build.dart';

// ignore: must_be_immutable
class PerkDeckCard extends StatefulWidget {
  
  Build curntBuild;
  bool editable;

  PerkDeckCard(this.curntBuild, this.editable);

  @override
  _PerkDeckCardState createState() => _PerkDeckCardState(curntBuild, editable);
}

class _PerkDeckCardState extends State<PerkDeckCard> {
  bool editable;
  String perkVal;
  Build curntBuild;

  _PerkDeckCardState(this.curntBuild, this.editable);

  @override
  Widget build(BuildContext context) {
    perkVal = curntBuild.getPerk();

    return Material(
      elevation: 3,
      color: kSurfaceColor,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            editable?
            DropdownButton<String>(
              value: perkVal,
              elevation: 1,
              onChanged: (String newPerk) {
                setState(() {
                  perkVal = newPerk;
                  curntBuild.setPerk(perkVal);
                });
              },
              items: PdIcons.perksNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
            ):
            Text(
              curntBuild.getPerk(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),

            //Spaced
            SizedBox(
              width: 20,
            ),

            //Perk Icon
            Container(
              height: 75,
              width: 75,
              child: ClipRect(
                child: FittedBox(
                  child: Align(
                    alignment: Alignment(
                      //x
                      (PdIcons.perksLocations[PdIcons.perksNames.indexOf(curntBuild.getPerk())][0]*(2/4))-1,
                      //y
                      (PdIcons.perksLocations[PdIcons.perksNames.indexOf(curntBuild.getPerk())][1]*(2/21))-1
                    ),
                    heightFactor: 0.045,
                    widthFactor: 0.2,
                    child: Image.asset(
                      "assets/images/perkdecks/icons.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
