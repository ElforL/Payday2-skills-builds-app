import 'package:flutter/material.dart';
import 'package:pd2_builds/constants.dart';
import 'package:pd2_builds/screens/BuildsSceens/BuildEdit.dart';
import 'package:pd2_builds/screens/BuildsSceens/Components/SkillsCard.dart';
import 'package:pd2_builds/skills/Build.dart';
import 'package:pd2_builds/skills/BuildsServices.dart';

import 'Components/PerkDeckCard.dart';

// ignore: must_be_immutable
class BuildPreviewPage extends StatefulWidget {

  List<Build> buildsList;
  Build curntBuild;

  BuildPreviewPage(this.buildsList, this.curntBuild);

  @override
  _BuildPreviewPageState createState() => _BuildPreviewPageState();
}

class _BuildPreviewPageState extends State<BuildPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.curntBuild.getTitle(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
        actions: <Widget>[

          IconButton(
            padding: EdgeInsets.all(20),
            icon: Icon(Icons.text_fields),
            onPressed: (){
              showExpStringDialog(context);
            }
          )

        ],
      ),
      body: Column(
        children: <Widget>[

          //////////////////////////// Skills Card ////////////////////////////
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SkillsCard(curntBuild:widget.curntBuild, editable: false),
            ),
          ),
          //////////////////////////// Perk Deck ////////////////////////////
          Expanded(child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: PerkDeckCard(widget.curntBuild,false),
          )),

          //////////////////////////// Edit/Del Buttons ////////////////////////////
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Discard
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: kErrorColor)
                ),
                textColor: kErrorColor,
                onPressed: (){
                  showDeleteDialog(context);
                  // widget.buildsList.remove(widget.curntBuild);
                  // Navigator.pop(context);
                },
                child: Text("DELETE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ),
              SizedBox(width: 100,),
              //Save
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: kSecondaryColor)
                ),
                textColor: kSecondaryColor,
                child: Text("EDIT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async{
                  //Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuildEditPage(widget.curntBuild, widget.buildsList))
                  );
                  setState(() {
                    
                  });
                },
              ),
            ],
          ),

        ],
      ),
    );
  }

  showExpStringDialog(BuildContext context){
    EdgeInsets padding = EdgeInsets.only(left: 20, right: 20);
    // set up the buttons
    Widget okButton = FlatButton(
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: kSecondaryColor,
          width: 2
        ),
      ),
      textColor: kSecondaryColor,
      child: Text("OK"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog popup = AlertDialog(
      backgroundColor: kSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Text("String of ${widget.curntBuild.getTitle()}"),
      content: TextField(
        maxLines: null,
        readOnly: true,
        controller: TextEditingController(
          text: widget.curntBuild.getExportString()
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return popup;
      },
    );
  }
  
  showDeleteDialog(BuildContext context) {
    EdgeInsets padding = EdgeInsets.only(left: 20, right: 20);
    // set up the buttons
    Widget cancelButton = FlatButton(
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: kSecondaryColor,
          width: 2
        ),
      ),
      textColor: kSecondaryColor,
      child: Text("CANCEL",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    Widget deleteButton = FlatButton(
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      color: kErrorColor,
      textColor: kTextOnError,
      child: Text("DELETE",style: TextStyle(fontWeight: FontWeight.bold),),
      onPressed:  () {
        Navigator.pop(context);
        widget.buildsList.remove(widget.curntBuild);
        BuildsServices.writeToFile(widget.buildsList);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: kSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Text("Delete ${widget.curntBuild.getTitle()} ?"),
      content: Text("Are you sure you want to delete '${widget.curntBuild.getTitle()}' ?"),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

