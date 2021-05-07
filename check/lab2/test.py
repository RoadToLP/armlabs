import random
dimensions = (random.randint(4, 20), random.randint(4, 30))
print(dimensions)
data = [random.choices(range(0, 0xFFFF), k=dimensions[0]) for i in range(dimensions[1])]

print("Testing array")
print('\n'.join(['  '.join([str(data[i][j]) for j in range(dimensions[0])]) for i in range(dimensions[1])]))

f = open("exec", 'w')
f.write(str(dimensions[0])+'\n')
f.write(str(dimensions[1])+'\n')
for i in range(0, dimensions[0]):
    for j in range(0, dimensions[1]):
        f.write(str(data[j][i]) + '\n')

f.close()
