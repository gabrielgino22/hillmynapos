import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../widgets/collapsible_nav.dart'; // Ensure this path is correct

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? selectedServiceId;
  String? selectedCategoryId;
  List<Map<String, dynamic>> cart = [];
  String? customerName;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  double totalAmount = 0.0;
  String? discountType;
  String? paymentMethod;
  bool isNavRailExtended = false;
  final _logger = Logger('ServicesPage');

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0; // Initialize to Services page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CollapsibleNav(
            selectedIndex: _selectedIndex, // Pass the current selected index
            onDestinationSelected: _handleNavigation,
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Column(
                children: [
                  // Simple AppBar
                  Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.26), // Fixed: Use withOpacity
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Main content area
                  Expanded(
                    child: Row(
                      children: [
                        // Services grid
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: StreamBuilder<QuerySnapshot>(
                              stream:
                                  _firestore.collection('services').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('Something went wrong'));
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                final items = snapshot.data?.docs ?? [];

                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 0.85,
                                    mainAxisSpacing: 16,
                                    crossAxisSpacing: 16,
                                  ),
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return _buildItemCard(items[index]);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        // Cart section
                        Container(
                          width: 300,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                color: Colors.green.shade50,
                                child: Row(
                                  children: [
                                    const Icon(Icons.shopping_cart),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Current Order',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (cart.isNotEmpty)
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            cart.clear();
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: cart.length,
                                  itemBuilder: (context, index) {
                                    final item = cart[index];
                                    return ListTile(
                                      title: Text(item['name']),
                                      subtitle: Text(
                                          '₱${item['price'].toStringAsFixed(2)}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              setState(() {
                                                if (item['quantity'] > 1) {
                                                  item['quantity']--;
                                                } else {
                                                  cart.removeAt(index);
                                                }
                                              });
                                            },
                                          ),
                                          Text('${item['quantity']}'),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                item['quantity']++;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withAlpha(50),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total:',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '₱${_calculateTotal().toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: cart.isEmpty
                                          ? null
                                          : _showPaymentOverlay,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        minimumSize:
                                            const Size(double.infinity, 48),
                                      ),
                                      child: const Text('Process Order'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(DocumentSnapshot item) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _addToCart(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: item['imageUrl'] != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                      child: Image.network(
                        item['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      color: Colors.green.shade50,
                      child: Icon(
                        Icons.spa,
                        size: 64,
                        color: Colors.green.shade300,
                      ),
                    ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₱${item['price'].toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(DocumentSnapshot item) {
    setState(() {
      final existingItemIndex =
          cart.indexWhere((element) => element['id'] == item.id);
      if (existingItemIndex != -1) {
        cart[existingItemIndex]['quantity']++;
      } else {
        cart.add({
          'id': item.id,
          'name': item['name'],
          'price': item['price'],
          'quantity': 1,
        });
      }
    });
  }

  double _calculateTotal() {
    totalAmount = cart.fold(
        0, (total, item) => total + (item['price'] * item['quantity']));
    if (discountType == '20% PWD' || discountType == '20% Senior') {
      totalAmount *= 0.8;
    }
    return totalAmount;
  }

  void _showPaymentOverlay() {
    if (customerName == null || customerName!.isEmpty) {
      // Show customer name dialog first
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Customer Details'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Customer Name',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => customerName = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPaymentDetails();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    } else {
      _showPaymentDetails();
    }
  }

  void _showPaymentDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: discountType,
                  decoration: const InputDecoration(
                    labelText: 'Discount Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('No Discount'),
                    ),
                    DropdownMenuItem(
                      value: '20% PWD',
                      child: Text('20% PWD'),
                    ),
                    DropdownMenuItem(
                      value: '20% Senior',
                      child: Text('20% Senior'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      discountType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Cash',
                      child: Text('Cash'),
                    ),
                    DropdownMenuItem(
                      value: 'Card',
                      child: Text('Card'),
                    ),
                    DropdownMenuItem(
                      value: 'Online',
                      child: Text('Online'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      paymentMethod = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _processOrder();
                    _showReceiptOverlay();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Confirm Payment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showReceiptOverlay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Text('Receipt'),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Receipt content
              Text('Customer: $customerName'),
              const Divider(),
              // ... receipt items ...
              Text('Total: ₱${_calculateTotal().toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // Implement print functionality
            },
            icon: const Icon(Icons.print),
            label: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }

  void _processOrder() {
    // Implement order processing logic
    final double total = _calculateTotal();
    _logger.info('Order processed with total: ₱$total');
    setState(() {
      cart.clear();
      discountType = null;
      paymentMethod = null;
    });
  }

  void _handleNavigation(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0: // Services
          // Already on Services page
          break;
        case 1: // Shift
          Navigator.pushNamed(context, '/shift').then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
        case 2: // Edit Services
          Navigator.pushNamed(context, '/edit-services').then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
        case 3: // Receipts
          Navigator.pushNamed(context, '/receipts').then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
        case 4: // Settings
          Navigator.pushNamed(context, '/settings').then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
        case 5: // Back Office
          Navigator.pushNamed(context, '/back-office').then((_) {
            setState(() {
              _selectedIndex = 0;
            });
          });
          break;
      }
    }
  }
}
