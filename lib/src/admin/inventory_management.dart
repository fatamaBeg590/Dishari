import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({super.key});

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement> {
  final Color primaryColor = const Color(0xFF00796B); // Deep Teal
  final Color lowStockColor = Colors.orange.shade700;
  final Color criticalStockColor = Colors.red.shade700;

  // UPDATED: Dummy data structure to support multiple batches per medicine
  List<Map<String, dynamic>> products = [
    {
      "name": "Oxygen",
      "unit": "Tanks",
      "minThreshold": 20,
      "batches": [
        {"batchId": "OXY-A", "stock": 15, "expiry": DateTime(2026, 6, 30)},
      ],
    },
    {
      "name": "Amoxicillin",
      "unit": "Boxes",
      "minThreshold": 50,
      "batches": [
        {"batchId": "AMX-1", "stock": 70, "expiry": DateTime(2025, 12, 31)},
        {"batchId": "AMX-2", "stock": 50, "expiry": DateTime(2026, 3, 15)},
      ],
    },
    {
      "name": "Insulin",
      "unit": "Vials",
      "minThreshold": 10,
      "batches": [
        {"batchId": "INS-X", "stock": 3, "expiry": DateTime(2025, 11, 15)}, // Critical stock
      ],
    },
    {
      "name": "Napa (Paracetamol)", // Example of medicine with multiple batches
      "unit": "Tablets",
      "minThreshold": 100,
      "batches": [
        {"batchId": "NAPA-001", "stock": 300, "expiry": DateTime(2025, 10, 20)}, // Earliest Expiry
        {"batchId": "NAPA-002", "stock": 130, "expiry": DateTime(2026, 1, 10)},
      ],
    },
    {
      "name": "Saline",
      "unit": "Bags",
      "minThreshold": 60,
      "batches": [
        {"batchId": "SAL-01", "stock": 50, "expiry": DateTime(2025, 10, 20)}, // Low stock
      ],
    },
  ];

  // NEW: Calculate total stock from all batches
  int _getTotalStock(Map<String, dynamic> product) {
    List<Map<String, dynamic>> batches = product['batches'];
    return batches.fold(0, (sum, batch) => sum + (batch['stock'] as int));
  }

  // NEW: Find the earliest expiry date (FEFO principle)
  DateTime _getEarliestExpiry(Map<String, dynamic> product) {
    final batches = product['batches'] as List<Map<String, dynamic>>;
    if (batches.isEmpty) return DateTime(2100); // Safely return future date if no batches

    DateTime earliest = batches.first['expiry'];
    for (var batch in batches) {
      if (batch['expiry'].isBefore(earliest)) {
        earliest = batch['expiry'];
      }
    }
    return earliest;
  }

  // Function to determine stock status color and message (uses total stock)
  Map<String, dynamic> _getStockStatus(Map<String, dynamic> product) {
    final stock = _getTotalStock(product);
    final threshold = product['minThreshold'];

    if (stock <= 0) {
      return {"color": criticalStockColor, "text": "Out of Stock"};
    } else if (stock < threshold) {
      return {"color": lowStockColor, "text": "Low Stock Alert!"};
    }
    return {"color": primaryColor.withOpacity(0.7), "text": "In Stock"};
  }

  // --- Dialogs & Actions ---

  void _viewMedicine(Map<String, dynamic> product) {
    final _batchIdController = TextEditingController();
    final _quantityController = TextEditingController();
    DateTime _selectedExpiryDate = DateTime.now().add(const Duration(days: 365)); // Default to 1 year later

    showDialog(
      context: context,
      builder: (context) {
        String? _errorText;

        // StatefulBuilder allows us to update the dialog state (like error text or expiry date)
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(product['name'], style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Stock: ${_getTotalStock(product)} ${product['unit']}", style: const TextStyle(fontSize: 16)),
                    Text("Earliest Expiry: ${DateFormat('yyyy-MM-dd').format(_getEarliestExpiry(product))}", style: const TextStyle(fontSize: 16)),
                    const Divider(),

                    // Display Current Batches
                    const Text("Current Batches:", style: TextStyle(fontWeight: FontWeight.bold)),
                    ... (product['batches'] as List<Map<String, dynamic>>).map((batch) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text("ID: ${batch['batchId']} | Stock: ${batch['stock']} | Expires: ${DateFormat('yy-MM').format(batch['expiry'])}"),
                      );
                    }),

                    const Divider(),
                    const Text("Add New Batch:", style: TextStyle(fontWeight: FontWeight.bold)),

                    // Input field for Batch ID
                    TextField(
                      controller: _batchIdController,
                      decoration: const InputDecoration(
                        labelText: "New Batch ID (e.g., NAPA-003)",
                      ),
                    ),

                    // Input field for Restock Quantity
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Quantity to Add",
                        errorText: _errorText, // Show red error text if validation fails
                      ),
                    ),

                    // Expiry Date Picker for New Batch
                    ListTile(
                      title: const Text("Select Expiry Date:"),
                      subtitle: Text(DateFormat('yyyy-MM-dd').format(_selectedExpiryDate)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedExpiryDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null && picked != _selectedExpiryDate) {
                          setStateDialog(() {
                            _selectedExpiryDate = picked;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // New Batch Add Button
                    ElevatedButton.icon(
                      onPressed: () {
                        final quantityText = _quantityController.text;
                        final batchId = _batchIdController.text.trim();
                        final quantity = int.tryParse(quantityText);

                        if (batchId.isEmpty || quantity == null || quantity <= 0) {
                          setStateDialog(() {
                            _errorText = "Enter a valid Batch ID and positive Quantity.";
                          });
                          return;
                        }else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${product['name']} - Batch $batchId added with $quantity ${product['unit']}."
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        };
                        //Add the new batch
                        setState(() {
                          final batches = List<Map<String, dynamic>>.from(product['batches'] ?? []);
                          batches.add({
                            "batchId": batchId,
                            "stock": quantity,
                            "expiry": _selectedExpiryDate,
                          });
                          product['batches'] = batches; // Update product map with new mutable list
                        });


                      },
                      icon: const Icon(Icons.add_circle, color: Colors.white),
                      label: const Text("Add New Batch", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
              ],
            );
          },
        );
      },
    ).then((_) {
      // Dispose controllers after dialog closes
      _batchIdController.dispose();
      _quantityController.dispose();
    });
  }

  void _showAddMedicineDialog() {
    final TextEditingController medicineIdController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController unitController = TextEditingController();
    final TextEditingController minStockController = TextEditingController(text: "10");
    final TextEditingController typeController = TextEditingController();

    bool _isIdValid = true;
    bool _isNameValid = true;
    bool _isUnitValid = true;
    bool _isMinStockValid = true;
    bool _isTypeValid = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("Add New Medicine"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: medicineIdController,
                      decoration: InputDecoration(
                        labelText: "Medicine ID",
                        errorText: _isIdValid ? null : "Required",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Medicine Name",
                        errorText: _isNameValid ? null : "Required",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: unitController,
                      decoration: InputDecoration(
                        labelText: "Unit (e.g. tablet,capsul)",
                        errorText: _isUnitValid ? null : "Required",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: minStockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Minimum Stock",
                        errorText: _isMinStockValid ? null : "Required",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: typeController,
                      decoration: InputDecoration(
                        labelText: "Type (e.g. Antibiotic, Painkiller)",
                        errorText: _isTypeValid ? null : "Required",
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    bool isValid = true;

                    if (medicineIdController.text.isEmpty) {
                      isValid = false;
                      setStateDialog(() => _isIdValid = false);
                    } else {
                      setStateDialog(() => _isIdValid = true);
                    }

                    if (nameController.text.isEmpty) {
                      isValid = false;
                      setStateDialog(() => _isNameValid = false);
                    } else {
                      setStateDialog(() => _isNameValid = true);
                    }

                    if (unitController.text.isEmpty) {
                      isValid = false;
                      setStateDialog(() => _isUnitValid = false);
                    } else {
                      setStateDialog(() => _isUnitValid = true);
                    }

                    if (minStockController.text.isEmpty) {
                      isValid = false;
                      setStateDialog(() => _isMinStockValid = false);
                    } else {
                      setStateDialog(() => _isMinStockValid = true);
                    }

                    if (typeController.text.isEmpty) {
                      isValid = false;
                      setStateDialog(() => _isTypeValid = false);
                    } else {
                      setStateDialog(() => _isTypeValid = true);
                    }

                    if (!isValid) return;

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Medicine added successfully")),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00796B)),
                  child: const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    // Filter based on total stock
    final lowStockItems = products.where((p) => _getTotalStock(p) < p['minThreshold']).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Low Stock Alerts Section
          if (lowStockItems.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "🔴 Low Stock Alerts (${lowStockItems.length})",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: criticalStockColor),
                    ),
                    const SizedBox(height: 8),
                    ...lowStockItems.map((product) {
                      return Card(
                        color: lowStockColor.withOpacity(0.1),
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: lowStockColor)),
                        child: ListTile(
                          leading: Icon(Icons.warning, color: lowStockColor),
                          title: Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold, color: lowStockColor)),
                          subtitle: Text("Current Stock: ${_getTotalStock(product)} ${product['unit']}. Threshold: ${product['minThreshold']}"),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _viewMedicine(product),
                        ),
                      );
                    }),
                    const Divider(height: 30),
                  ],
                ),
              ),
            ),

          // Main Inventory List Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "All Inventory Items",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
          ),

          // Main Inventory List
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final product = products[index];
                final status = _getStockStatus(product);
                final earliestExpiry = _getEarliestExpiry(product);
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: status['color'].withOpacity(0.2),
                      child: Icon(Icons.healing, color: status['color']),
                    ),
                    title: Text(
                      product['name'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stock: ${_getTotalStock(product)} ${product['unit']} (${status['text']})",
                          style: TextStyle(fontWeight: FontWeight.bold, color: status['color']),
                        ),
                        Text("Earliest Expiry: ${DateFormat('yyyy-MM-dd').format(earliestExpiry)}"),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () => _viewMedicine(product),
                      icon: const Icon(Icons.info_outline, color: Colors.blueGrey),
                    ),
                  ),
                );
              },
              childCount: products.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicineDialog,
        label: const Text("Add Medicine", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}