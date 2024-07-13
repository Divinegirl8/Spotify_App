
class CategoryModel{

String iconPath;
String name;
String description;


CategoryModel({
  required this.iconPath,
  required this.name,
  required this.description
});


static List<CategoryModel> getCategory(){
  List<CategoryModel> categories = [];
      categories.add(
    CategoryModel(
      iconPath: "images/img8.jpg",
       name: "Top 50 Global",
       description:"""
Your weekly update of 
the most played track
                  """  
      )
  );

  categories.add(
    CategoryModel(
      iconPath: "images/img9.jpg",
       name: "Top 50 India",
       description:"""
Your weekly update of 
the most played track
                  """ 
      )
  );

    categories.add(
    CategoryModel(
      iconPath: "images/img10.jpg",
       name: "Trending India",
       description:"""
Your weekly update of 
the most played track
""" 
      )
  );


    categories.add(
    CategoryModel(
      iconPath: "images/img16.jpg",
       name: "Trending Global",
       description:"""
Your weekly update of 
the most played track
""" 
      )
  );


      categories.add(
    CategoryModel(
      iconPath: "images/img11.jpg",
       name: "Mega Hits",
      description:"""
Your weekly update of 
the most played track
""" )
  );


      categories.add(
    CategoryModel(
      iconPath: "images/img15.jpg",
       name: "Happy Favourites",
      description:"""
Your weekly update of 
the most played track
                  """ 
      )
  );

  return categories;
}
  


}