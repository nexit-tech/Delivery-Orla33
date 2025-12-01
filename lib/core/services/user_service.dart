import 'package:flutter/material.dart';
import '../models/address_model.dart';

class UserService extends ChangeNotifier {
  static final UserService instance = UserService._();
  UserService._();

  // Dados do Usuário Mockados (Iniciais)
  String name = "Vaelor Velaryon";
  String email = "vaelor@driftmark.com";

  // Lista de Endereços Salvos
  final List<AddressModel> _savedAddresses = [
    AddressModel(street: "Rua Tokyo", number: "123", district: "Centro", complement: "Apto 101"),
  ];

  List<AddressModel> get savedAddresses => List.unmodifiable(_savedAddresses);

  // Atualizar Perfil
  void updateProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
    notifyListeners();
  }

  // Adicionar Endereço
  void addAddress(AddressModel address) {
    _savedAddresses.add(address);
    notifyListeners();
  }

  // Remover Endereço
  void removeAddress(AddressModel address) {
    _savedAddresses.remove(address);
    notifyListeners();
  }
}