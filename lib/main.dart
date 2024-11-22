import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set primarySwatch globally
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue, // Set AppBar color to blue
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue, // Set FAB color to blue
        ),
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, String>> _todos = [];

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String orderId = "";
        String orderDate = "";
        String planName = "";
        String orderStatus = "";
        return AlertDialog(
          title: Text(
            "Add a new To-Do",
            style: TextStyle(
              fontWeight: FontWeight.bold, // Make title bold
              color: Colors.blue, // Title color
            ),
          ),
          backgroundColor: Colors.white, // Set background color of dialog to white
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Order ID - Only numbers allowed
                TextField(
                  decoration: InputDecoration(
                    labelText: "Order ID",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text for label
                      color: Colors.black, // Label color
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    orderId = value;
                  },
                ),
                // Order Date - Only valid date format allowed
                TextField(
                  decoration: InputDecoration(
                    labelText: "Order Date (YYYY-MM-DD)",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text for label
                      color: Colors.black, // Label color
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  onChanged: (value) {
                    orderDate = value;
                  },
                ),
                // Plan Name - Text field
                TextField(
                  decoration: InputDecoration(
                    labelText: "Plan Name",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text for label
                      color: Colors.black, // Label color
                    ),
                  ),
                  onChanged: (value) {
                    planName = value;
                  },
                ),
                // Order Status - Text field
                TextField(
                  decoration: InputDecoration(
                    labelText: "Order Status",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, // Bold text for label
                      color: Colors.black, // Label color
                    ),
                  ),
                  onChanged: (value) {
                    orderStatus = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Blue background
              onPressed: () {
                // Validate Order ID (only numbers allowed)
                if (orderId.isNotEmpty && int.tryParse(orderId) != null &&
                    orderDate.isNotEmpty && _isValidDate(orderDate) &&
                    planName.isNotEmpty && orderStatus.isNotEmpty) {
                  setState(() {
                    _todos.add({
                      "Order ID": orderId,
                      "Order Date": orderDate,
                      "Plan Name": planName,
                      "Order Status": orderStatus,
                      "Action": "Edit Delete Submit", // Default Action name
                    });
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter valid data for all fields."),
                    ),
                  );
                }
              },
              child: Text(
                "Add",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white), // Make button text bold
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Blue background
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white), // Make button text bold
              ),
            ),
          ],
        );
      },
    );
  }

  // Date validation function
  bool _isValidDate(String date) {
    try {
      DateFormat("yyyy-MM-dd").parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Function to handle "Create Account" action
  void _createAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Create Account option selected."),
      ),
    );
  }

  // Function to handle Pending option and submenu options
  void _handlePendingOption(String value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$value option selected."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          // Three-dot icon with a menu to show "Create Account" option and "Pending" submenu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert), // Three-dot icon
            onSelected: (value) {
              if (value == 'Create Account') {
                _createAccount(); // Handle "Create Account" action
              } else if (value == 'Pending') {
                // Handle "Pending" option and its sub-options
                _showPendingSubmenu(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Create Account',
                  child: Text("Create Account"), // Option in the menu
                ),
                PopupMenuItem<String>(
                  value: 'Pending',
                  child: Text("Pending"), // "Pending" option in the menu
                ),
              ];
            },
          ),
          SizedBox(width: 16), // Space between the icon and edge of the screen
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.white], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Order ID: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "${_todos[index]["Order ID"]}\n"),
                      TextSpan(
                        text: "Order Date: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "${_todos[index]["Order Date"]}\n"),
                      TextSpan(
                        text: "Plan Name: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "${_todos[index]["Plan Name"]}\n"),
                      TextSpan(
                        text: "Order Status: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: "${_todos[index]["Order Status"]}\n"),
                      TextSpan(
                        text: "Action: ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "${_todos[index]["Action"]}",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: IconButton(
                    icon: Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Refreshed item: ${_todos[index]["Order ID"]}"),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: Colors.blue, // Button color
        child: Icon(Icons.add), // Icon inside the button
        shape: CircleBorder(), // Ensures the button remains circular
      ),
    );
  }

  // Show the Pending submenu with 4 options
  void _showPendingSubmenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pending Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Option 1"),
                onTap: () {
                  _handlePendingOption("Option 1");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Option 2"),
                onTap: () {
                  _handlePendingOption("Option 2");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Option 3"),
                onTap: () {
                  _handlePendingOption("Option 3");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Option 4"),
                onTap: () {
                  _handlePendingOption("Option 4");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
