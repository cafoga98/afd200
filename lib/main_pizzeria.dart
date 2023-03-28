import 'dart:convert';
import 'dart:io';

enum Size { big, medium, small }

void main() {
  Message().welcome();
  if(GetResponse(stdin.readLineSync(encoding: utf8)).part1()){
    GetResponse(stdin.readLineSync(encoding: utf8)).part2();
  }else{
    Message().farewell();
  }
}

class Menu {
  List<Order>? cartShopping = [];
  String? getTotalShopping() => cartShopping?.map((e) => e.price).toList().reduce((value, element) => value! + element!).toString();

  Order getPrice({required Size size}) {
    switch (size) {
      case Size.big:
        return Order(price: 30000, product: "(1) Pizza Familiar");
      case Size.medium:
        return Order(price: 25000, product: "(2) Pizza Mediana");
      case Size.small:
        return Order(price: 15000, product: "(3) Pizza Pequeña");
      default:
        throw "Producto no existente";
    }
  }
}

class GetResponse extends Message {
  final String? response;

  GetResponse(this.response);

  bool part1() {
    if(response?.trim().toUpperCase() == "SI"){
      ourMenu(menu: Menu());
      return true;
    }else{
      return false;
    }
  }

  void part2() {
    Menu menu = Menu();
    switch(response?.trim().toUpperCase()){
      case "1":
        Order product = menu.getPrice(size: Size.big);
        menu.cartShopping?.add(product);
        totalBill(order: product, totalBill: menu.getTotalShopping());
        break;
      case "2":
        Order product = menu.getPrice(size: Size.medium);
        menu.cartShopping?.add(product);
        totalBill(order: product, totalBill: menu.getTotalShopping());
        break;
      case "3":
        Order product = menu.getPrice(size: Size.small);
        menu.cartShopping?.add(product);
        totalBill(order: product, totalBill: menu.getTotalShopping());
        break;
      default:
        farewell();
        break;
    }
  }
}

class Message {
  void welcome() {
    print(
        "===== Bienvenido a Pizzas Dart =====\n- Prodria tomar su orden ?\n\nSi/No");
  }

  void ourMenu({required Menu menu}) {
    print("Menu\n"
        "Por favor seleccione el tamaño a comprar:\n"
        "${menu.getPrice(size: Size.big).toPhrase()}\n"
        "${menu.getPrice(size: Size.medium).toPhrase()}\n"
        "${menu.getPrice(size: Size.small).toPhrase()}\n");
  }

  void totalBill({required Order order, required String? totalBill}){
    print("El producto ${order.product} fue agregado con exito !.\n"
        "Total Facturado: $totalBill\n");
    farewell();
  }

  void farewell(){
    print("Gracias por preferirnos !");
  }
}

class Order {
  double? price;
  String? product;

  Order({required this.price, required this.product});

  Order.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    product = json['product'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['product'] = product;
    return data;
  }

  String toPhrase() => "$product \$$price";
}
