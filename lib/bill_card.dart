import 'package:flutter/material.dart';
import 'prediction.dart';

class BillCardUI extends StatefulWidget {
  final Prediction prediction;

  const BillCardUI({
    Key? key,
    required this.prediction,
  }) : super(key: key);

  @override
  _BillCardUIState createState() => _BillCardUIState();
}

class _BillCardUIState extends State<BillCardUI> {
  Card _buildBreakdownCard(RecycleObject object) {
    return Card(
      color: Colors.lightGreen,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                object.name,
                style: TextStyle(fontSize: 14, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                object.count.toString(),
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${object.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${(object.price * object.count).toStringAsFixed(2)}',
                style: TextStyle(fontSize: 14, color: Colors.white),
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
      margin: EdgeInsets.only(left: 15.0, right: 15.0),
      height: 490,
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25.0),
          bottomRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 8,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 8,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '       Article',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '           Qty.',
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
          ),
          Divider(color: Colors.grey),
          Container(
            height: 350,
            child: ListView.builder(
              itemCount: widget.prediction.objects.length,
              itemBuilder: (context, index) {
                return _buildBreakdownCard(widget.prediction.objects[index]);
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}