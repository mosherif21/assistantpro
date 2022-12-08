class AssistantProProduct {
  late final String _productName;
  late final String _macAddress;
  late final String _getTopic;
  late final String _setTopic;
  late final String _productId;
  late String _usageName = '';
  AssistantProProduct({
    required String productName,
    required String macAddress,
    required String getTopic,
    required String setTopic,
    required String usageName,
    required String productId,
  }) {
    _usageName = usageName;
    _macAddress = macAddress;
    _productName = productName;
    _getTopic = getTopic;
    _setTopic = setTopic;
    _productId = productId;
  }
  String getProductName() {
    return _productName;
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
