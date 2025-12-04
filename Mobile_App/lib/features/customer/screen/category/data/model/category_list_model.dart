class GetAllCategoryListModelResponse {
  bool? success;
  List<Data>? data;

  GetAllCategoryListModelResponse({this.success, this.data});

  GetAllCategoryListModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? categoryid;
  String? categoryimage;
  String? categoryname;
  String? categorydes;
  bool? categorystatus;
  String? categoryimagepath;

  Data(
      {this.categoryid,
        this.categoryimage,
        this.categoryname,
        this.categorydes,
        this.categorystatus,
        this.categoryimagepath});

  Data.fromJson(Map<String, dynamic> json) {
    categoryid = json['categoryid'];
    categoryimage = json['categoryimage'];
    categoryname = json['categoryname'];
    categorydes = json['categorydes'];
    categorystatus = json['categorystatus'];
    categoryimagepath = json['categoryimagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryid'] = categoryid;
    data['categoryimage'] = categoryimage;
    data['categoryname'] = categoryname;
    data['categorydes'] = categorydes;
    data['categorystatus'] = categorystatus;
    data['categoryimagepath'] = categoryimagepath;
    return data;
  }
}
