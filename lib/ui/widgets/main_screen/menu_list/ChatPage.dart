import 'package:flutter/material.dart';
// import 'package:chat_list/chat_list.dart';

class ChatPageView extends StatefulWidget {
  ChatPageView({Key? key}) : super(key: key);

  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  final ScrollController _scrollController = ScrollController();

  // final List<Message> _messageList = [
  //   Message(
  //       content: "Hi, Bill! This is the simplest example ever.",
  //       ownerType: OwnerType.sender,
  //       ownerName: "Higor Lapa"),
  //   Message(
  //       content:
  //           "Let's make it better , Higor. Custom font size and text color",
  //       textColor: Colors.black38,
  //       fontSize: 18.0,
  //       ownerType: OwnerType.receiver,
  //       ownerName: "Bill Gates"),
  //   Message(
  //       content: "Bill, we have to talk about business",
  //       fontSize: 12.0,
  //       ownerType: OwnerType.sender,
  //       ownerName: "Higor"),
  //   Message(
  //       content: "Wow, I like it. Tell me what I can do for you, pal.",
  //       ownerType: OwnerType.receiver,
  //       ownerName: "Bill Gates"),
  //   Message(
  //       content: "I'm just a copy",
  //       ownerType: OwnerType.sender,
  //       ownerName: "Higor"),
  //   Message(
  //       content: "Nice",
  //       ownerType: OwnerType.receiver,
  //       ownerName: "Bill Gates"),
  //   Message(
  //       content: "I'm just a copy",
  //       ownerType: OwnerType.sender,
  //       ownerName: "Higor"),
  //   Message(
  //       content: "Nice",
  //       ownerType: OwnerType.receiver,
  //       ownerName: "Bill Gates"),
  //   Message(
  //       content: "I'm just a copy",
  //       ownerType: OwnerType.receiver,
  //       ownerName: "Bill Gates"),
  //   Message(
  //       content: "Nice",
  //       ownerType: OwnerType.receiver,
  //       ownerName: "Bill Gates"),
  //   Message(
  //       content: "I'm just a copy",
  //       ownerType: OwnerType.sender,
  //       ownerName: "Higor"),
  //   Message(content: "Nice", ownerType: OwnerType.sender, ownerName: "Higor"),
  //   Message(
  //       content: "I'm just a copy",
  //       ownerType: OwnerType.sender,
  //       ownerName: "Higor"),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чат'),
      ),
      body: Center(
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                _onNewMessage();
              },
              child: Text('new msg!'),
            ),
            // ChatList(
            //   children: _messageList,
            //   scrollController: _scrollController,
            // ),
          ],
        ),
      ),
    );
  }

  void _onNewMessage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }
}
