class Product {
  String Actual_Product_price,
      Merchant_id,
      Product_brand,
      Product_category,
      Product_description,
      Product_id,
      Product_more_description,
      Product_name,
      Product_nick_name,
      Real_Product_price,
      image0,
      image1,
      image2,
      image3,
      image_name0,
      image_name1,
      image_name2,
      image_name3,
      published_on_date,
      published_on_time,
      speciality,
      z_main_value,
      z_value_types,
      z_variable_values,
      Wish_list_id;
  int discount;

  Product(
      this.Actual_Product_price,
      this.Merchant_id,
      this.Product_brand,
      this.Product_category,
      this.Product_description,
      this.Product_id,
      this.Product_more_description,
      this.Product_name,
      this.Product_nick_name,
      this.Real_Product_price,
      this.discount,
      this.image0,
      this.image1,
      this.image2,
      this.image3,
      this.image_name0,
      this.image_name1,
      this.image_name2,
      this.image_name3,
      this.published_on_date,
      this.published_on_time,
      this.speciality,
      this.z_main_value,
      this.z_value_types,
      this.z_variable_values,
      {this.Wish_list_id}
      );
}