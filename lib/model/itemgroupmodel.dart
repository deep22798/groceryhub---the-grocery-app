

class ItemGroupModel {
  dynamic? actionType;
  dynamic? clientprfix;
  dynamic? clienttransid;
  dynamic? groupType;
  dynamic? grpId;
  dynamic? isActive;
  dynamic? orgautoid;
  dynamic oldGroup;
  dynamic? productGroup;
  dynamic? svrupdyn;

  ItemGroupModel({
    this.actionType,
    this.clientprfix,
    this.clienttransid,
    this.groupType,
    this.grpId,
    this.isActive,
    this.orgautoid,
    this.oldGroup,
    this.productGroup,
    this.svrupdyn,
  });

  factory ItemGroupModel.fromJson(Map<dynamic, dynamic> json) => ItemGroupModel(
    actionType: json["ActionType"],
    clientprfix: json["CLIENTPRFIX"],
    clienttransid: json["CLIENTTRANSID"],
    groupType: json["GroupType"],
    grpId: json["GrpID"],
    isActive: json["IsActive"],
    orgautoid: json["ORGAUTOID"],
    oldGroup: json["OldGroup"],
    productGroup: json["ProductGroup"],
    svrupdyn: json["SVRUPDYN"],
  );

  Map<dynamic, dynamic> toJson() => {
    "ActionType": actionType,
    "CLIENTPRFIX": clientprfix,
    "CLIENTTRANSID": clienttransid,
    "GroupType": groupType,
    "GrpID": grpId,
    "IsActive": isActive,
    "ORGAUTOID": orgautoid,
    "OldGroup": oldGroup,
    "ProductGroup": productGroup,
    "SVRUPDYN": svrupdyn,
  };
}