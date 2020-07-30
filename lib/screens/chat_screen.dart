import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
FirebaseUser loggedinuser;


class ChatScreen extends StatefulWidget {

  static String chat = 'chats';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final mytexteditingcontroller = TextEditingController();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String messagetext;
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser()async{
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            mymessagestream(
              firestore: _firestore,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: mytexteditingcontroller,
                      onChanged: (value) {
                        messagetext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      mytexteditingcontroller.clear();
                      _firestore.collection('messages').add({'message': messagetext, 'Sender': loggedinuser.email });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class mymessagestream extends StatelessWidget {

  mymessagestream({this.firestore});
  final Firestore firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final messages = snapshot.data.documents.reversed;
          List<messagebubble> messagewidgets = [];
          for(var message in messages){
            final messagetext = message.data['message'];
            final messagesender = message.data['Sender'];

            final currentuser = loggedinuser.email;
            final messagewidget = messagebubble
              (text: messagetext, sender: messagesender,
              isme: currentuser == messagesender,
            );
            messagewidgets.add(messagewidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messagewidgets,
            ),
          );

          return null;
        }
    );
  }
}

class messagebubble extends StatelessWidget {

  messagebubble({this.isme, this.text, this.sender});
  final String text;
  final String sender;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender, style: TextStyle(
            fontSize: 8,
            color: Colors.black54
          ),),
          Material(
            elevation: 5,
            borderRadius: isme ?  BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)) :
            BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            color: isme? Colors.lightBlue : Colors.white54,
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text('$text', style: TextStyle(
                  color: isme ? Colors.white : Colors.black,
                  fontSize: 15
                ),),
              ),
          ),
        ],
      ),
    );
  }
}

