num_resource = int(input("Enter number of resource:"))
num_lead = int(input("Enter number of Team Lead:"))

request = []
resource = []
for i in range(num_resource):
    resource.append(i+1)

for i in range(num_lead):
    r = input("Enter request for T{} separated by comma:".format(i+1))
    request.append(r.split(','))

def round_robin_pick(request, resource, num_lead):
    taken = {}
    result = []
    for i in range(num_lead):
        result.append([])
    for i in range(int(len(resource)/num_lead)):
        for j in range(len(request)):
            if len(request[j]) > i:
                if request[j][i] in taken:
                    for k in resource:
                        if str(k) not in taken:
                            taken[str(k)] = j
                            result[j].append(str(k))
                            break
                else:
                    taken[request[j][i]] = j
                    result[j].append(request[j][i])
    return result

result = round_robin_pick(request, resource, num_lead)
for i in range(num_lead):
    print("T{}: {}".format(i+1, ','.join(result[i])))
