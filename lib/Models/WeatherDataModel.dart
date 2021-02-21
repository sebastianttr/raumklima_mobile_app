
class WeatherDataModel{
  String id;
  String sensorPosition;
  double temperature;
  int pressure;
  int humidity;
  DateTime lastSeen;

  WeatherDataModel(String id,String sensorPosition,double temperature,int pressure,int humidity){
    this.id = id;
    this.sensorPosition = sensorPosition;
    this.temperature = temperature;
    this.pressure = pressure;
    this.humidity = humidity;
  }
}