class HitsModel{
  String urlPath;
  String name;

  HitsModel({
    required this.urlPath,
    required this.name
  });

  static List<HitsModel> getHitModel(){
    List<HitsModel> models = [];

    models.add(
      HitsModel(
        urlPath: "images/img1.jpg",
        name: "song 1"
      )
    );


    models.add(
      HitsModel(
        urlPath: "images/img2.jpg",
        name: "song 2"
      )
    );


    models.add(
      HitsModel(
        urlPath: "images/img3.jpg",
        name: "song 3"
      )
    );


    models.add(
      HitsModel(
        urlPath: "images/img4.jpg",
        name: "song 4"
      )
    );


    models.add(
      HitsModel(
        urlPath: "images/img5.jpg",
        name: "song 5"
      )
    );


    models.add(
      HitsModel(
        urlPath: "images/img6.jpg",
        name: "song 6"
      )
    );

        models.add(
      HitsModel(
        urlPath: "images/img7.jpg",
        name: "song 7"
      )
    );


        models.add(
      HitsModel(
        urlPath: "images/img12.jpg",
        name: "song 12"
      )
    );

       models.add(
      HitsModel(
        urlPath: "images/img13.jpg",
        name: "song 13"
      )
    );


        models.add(
      HitsModel(
        urlPath: "images/img14.jpg",
        name: "song 14"
      )
    );

    return models;
  }


}