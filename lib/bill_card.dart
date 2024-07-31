import 'package:flutter/material.dart';

class BillCardUI extends StatefulWidget {
  final TextEditingController aluminiumCansController;
  final TextEditingController gableTopController;
  final TextEditingController glassBottleController;
  final TextEditingController milkGallonController;
  final TextEditingController plasticController;
  final TextEditingController tetrapackController;
  final TextEditingController objectController;

  const BillCardUI({
    Key? key,
    required this.aluminiumCansController,
    required this.gableTopController,
    required this.glassBottleController,
    required this.milkGallonController,
    required this.plasticController,
    required this.tetrapackController,
    required this.objectController,
  }) : super(key: key);

  @override
  _BillCardUIState createState() => _BillCardUIState();
}

class _BillCardUIState extends State<BillCardUI> {
  late final TextEditingController aluminiumCansController;
  late final TextEditingController gableTopController;
  late final TextEditingController glassBottleController;
  late final TextEditingController milkGallonController;
  late final TextEditingController plasticController;
  late final TextEditingController tetrapackController;
  late final TextEditingController objectController;

  @override
  void initState() {
    super.initState();
    aluminiumCansController = widget.aluminiumCansController;
    gableTopController = widget.gableTopController;
    glassBottleController = widget.glassBottleController;
    milkGallonController = widget.milkGallonController;
    plasticController = widget.plasticController;
    tetrapackController = widget.tetrapackController;
    objectController = widget.objectController;
  }

  Widget _buildBreakdownCard(String itemName, int count, double price) {
    return Card(
      color: Colors.lightGreen,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                itemName,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                count.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${(price * count).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
      height: 490,
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 8,
            offset: Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 8,
            offset: Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildTableHeader(),
          const Divider(color: Colors.grey),
          _buildItemList(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          child: Text(
            'Article',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Text(
            '         Qty.',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Price/Qty',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            'Price',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return SizedBox(
      height: 350,
      child: ListView(
        children: [
          _buildItemCard('Aluminium Cans', aluminiumCansController, 0.05),
          _buildItemCard('Gable Top', gableTopController, 0.05),
          _buildItemCard('Glass Bottle', glassBottleController, 0.10),
          _buildItemCard('Milk Gallon', milkGallonController, 0.20),
          _buildItemCard('Plastic', plasticController, 0.05),
          _buildItemCard('Tetrapack', tetrapackController, 0.05),
        ].whereType<Widget>().toList(),
      ),
    );
  }

  Widget? _buildItemCard(
      String itemName, TextEditingController controller, double price) {
    int count = int.tryParse(controller.text) ?? 0;
    return count != 0 ? _buildBreakdownCard(itemName, count, price) : null;
  }
}
