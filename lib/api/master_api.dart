import 'package:salon/api/dio_client.dart';
import 'package:salon/model/master_model/get_category_model.dart';

class MasterApi{
  static Future<List<GetCategoryData>> getCategory() async {
    final response = await DioClient.client.get('salon/service/category/list');
    if (response.statusCode == 200) {
      return response.data['data']
          .map<GetCategoryData>((e) => GetCategoryData.fromJson(e))
          .toList();
    } else {
      throw response.data;
    }
  }

}