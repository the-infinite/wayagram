import 'package:flutter/material.dart';

class RoleAccessCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const RoleAccessCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = user["isCurrentUser"] ?? false;
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      //  padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Profile Avatar or Initials
          user["image"] != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(user["image"]),
                  radius: 20,
                )
              : CircleAvatar(
                  backgroundColor: Colors.pink[100],
                  radius: 20,
                  child: Text(
                    getInitials(user["name"]),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
          SizedBox(width: 12),
          // Name and Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user["name"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (isCurrentUser)
                  Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        user["role"],
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ),
                    ],
                  )
                else
                  Text(
                    user["role"],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          // Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: user["status"] == "Active"
                  ? Colors.green[100]
                  : Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user["status"],
              style: TextStyle(
                color: user["status"] == "Active"
                    ? Colors.green[700]
                    : Colors.orange[700],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  String getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = names.length > 1
        ? names[0][0] + names[1][0] // First letter of first & last name
        : names[0][0]; // Only first letter if single name
    return initials.toUpperCase();
  }
}
