import pandas as pd
import json

# model name by brand name
# list1 = []
#
# df = pd.read_csv("washing machines.csv")
# df1 = df["Model Number"].groupby(df["Brand Name"]).count()
#
# temp = []
# for one in df["Brand Name"].unique():
#     temp.append(df[df["Brand Name"]==one]["Model Number"])
#
# final = []
# for tmp in temp:
#     list2 = []
#     for n in tmp:
#         n = str(n)
#         n.replace("'", "")
#         n.replace("\"", "")
#         m = "Model(name: \"" + n + "\", isSelected: false)"
#         list2.append(m)
#     final.append(list2)
#
# print(str(final).replace("'", ""))


# three values by brand name and model name
# df = pd.read_csv("washing machines.csv")
# df1 = df["Model Number"].groupby(df["Brand Name"]).count()
#
# temp = []
# name = ["Manufacturing Countries", "Comparative Energy Consumption", "Star Rating"]
# for one in df["Brand Name"].unique():
#     list1 = []
#     for two in df[df["Brand Name"] == one][name].values:
#         list1.append(list(two))
#
#     temp.append(list1)
#
# for i in range(len(temp)):
#     for j in range(len(temp[i])):
#         for n in range(0,3):
#             temp[i][j][n]=str(temp[i][j][n])
#
# print(json.dumps(temp))


# def duplicate(items):
# #     unique = []
# #     for item in items:
# #         if item not in unique:
# #             unique.append(item)
# #     return unique
# # df = pd.read_csv("washing machines.csv")
# # list1 = []
# # df1 =df["Brand Name"]
# #
# # for i in df1.values:
# #     list1.append(i)
# # list2 = duplicate(list1)
# #
# # for i in range(len(list2)):
# #     list2[i] = "Brand(name: \"" + list2[i] + "\", isSelected: false)"
# #
# # print(str(list2).replace("'",""))

df = pd.read_csv("washing machines.csv")
print(df.to_json(orient='values'))










"""
{
    "Computer Monitor": [
                            "ASUS": [
                                        "VE248***": {
                                                        "Manufacturing Countries": "China",
                                                        "Comparative Energy Consumption": "88",
                                                        "Star Rating": "4.5"
                                                    }
                                    ]
                        ]
}

"""