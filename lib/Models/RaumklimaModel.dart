  class RaumklimaModel{
    String raumBezeichnung;
    double temperatur;
    int humidtiy;
    int CO2;
    DateTime time;

    RaumklimaModel(
        String raumBezeichnung,
        double temperatur,
        int humidtiy,
        int CO2,
        DateTime time) {
      this.raumBezeichnung = raumBezeichnung;
      this.temperatur = temperatur;
      this.humidtiy = humidtiy;
      this.CO2 = CO2;
      this.time = time;
    }
  }