def serialize_2D(x, y):
    return "p" + str(x) + "-" + str(y)


#  7-9 p7-10
def deserialize_2D(data):
    data = data[1:]
    x, y = data.split("-")
    return int(x), int(y)
