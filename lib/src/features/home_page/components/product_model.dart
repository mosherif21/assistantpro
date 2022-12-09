import '../../../../mqtt/mqtt_product.dart';

class AssistantProProduct {
  late final String _productName;
  late final String _macAddress;
  late final String _getTopic;
  late final String _setTopic;
  late final String _productId;
  late final int _minimumQuantity;
  late final int _currentQuantity;
  late String _usageName = '';
  late MQTTProductHandler _mqttProductHandler;
  AssistantProProduct({
    required String productName,
    required String macAddress,
    required String getTopic,
    required String setTopic,
    required String usageName,
    required String productId,
    required int minimumQuantity,
    required int currentQuantity,
    required MQTTProductHandler mqttProductHandler,
  }) {
    _usageName = usageName;
    _macAddress = macAddress;
    _productName = productName;
    _getTopic = getTopic;
    _setTopic = setTopic;
    _productId = productId;
    _minimumQuantity = minimumQuantity;
    _currentQuantity = currentQuantity;
    _mqttProductHandler = mqttProductHandler;
    _mqttProductHandler.countTracker.value = currentQuantity;
    _mqttProductHandler.setCurrentQuantity(currentQuantity, _setTopic);
  }
  String getProductName() {
    return _productName;
  }

  int getCurrentQuantity() {
    return _currentQuantity;
  }

  int getMinimumQuantity() {
    return _minimumQuantity;
  }

  MQTTProductHandler getMqttProductHandler() {
    return _mqttProductHandler;
  }

  String getMacAddress() {
    return _macAddress;
  }

  String getGetTopic() {
    return _getTopic;
  }

  String getSetTopic() {
    return _setTopic;
  }

  String getUsageName() {
    return _usageName;
  }

  String getProductId() {
    return _productId;
  }

  void setUsageName(String usageName) {
    _usageName = usageName;
  }

  @override
  String toString() {
    return "($_productId, $_productName, $_macAddress, get:$_getTopic, set:$_setTopic, usage:$_usageName)";
  }
}
