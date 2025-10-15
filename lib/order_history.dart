import 'package:flutter/material.dart';
import 'all_files.dart';

class PendingOrdersPage extends StatefulWidget {
  const PendingOrdersPage({super.key});

  @override
  State<PendingOrdersPage> createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  bool showPending = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<CurrentUser>();

    Future<List<Map<String, dynamic>>> orders = (currentUser.role == 'vendor')
        ? getOrdersByVendor(currentUser.user!)
        : getOrdersByCustomer(currentUser.user!);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.teal,
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //toggle buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showPending = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showPending
                          ? Colors.teal
                          : Colors.teal.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Pending Orders",
                      style: TextStyle(
                        color: showPending ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => showPending = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showPending
                          ? Colors.teal
                          : Colors.teal.shade100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Completed Orders",
                      style: TextStyle(
                        color: !showPending ? Colors.white : Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Colors.teal),

          // order lists
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: orders,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No orders found.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                // Filter orders based on current view
                final ordersList = snapshot.data!.where((order) {
                  final status = (order["status"] ?? "pending").toLowerCase();
                  return showPending
                      ? status == "pending"
                      : status == "completed";
                }).toList();

                if (ordersList.isEmpty) {
                  return Center(
                    child: Text(
                      showPending
                          ? "No pending orders at the moment."
                          : "No completed orders yet.",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: ordersList.length,
                  itemBuilder: (context, index) {
                    final order = ordersList[index];
                    final name = order["productName"] ?? "Unnamed";
                    final productDetails = order["productDetails"] ?? '';
                    final cost = order["totalCost"]?.toString() ?? "N/A";
                    final expire = order["expireTime"]?.toString() ?? "Unknown";
                    final status = order["status"] ?? "pending";

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.shade400,
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Product details: $productDetails\nStatus: ${status.toString().toUpperCase()}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              trailing: Text(
                                "$cost৳",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            // ✅ “Order Completed?” button
                            if (status.toLowerCase() == 'pending')
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  bottom: 12,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await updateOrderStatus(order["id"]);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Order marked as completed ✅",
                                          ),
                                          backgroundColor: Colors.teal,
                                        ),
                                      );
                                      setState(() {}); // refresh page
                                    },
                                    icon: const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Order Completed?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
